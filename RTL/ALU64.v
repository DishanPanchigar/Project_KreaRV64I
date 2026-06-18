`timescale 1ns/1ps
module ALU64 (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire [3:0]  control,
    output reg  [63:0] result,
    output wire        Zero,
    output reg         flag,        // carry (ADD) / NOT borrow (SUB)
    output reg         overflow,
    output wire        Negative     // NEW
);

    wire is_add  = (control == 4'b0000);
    wire is_sub  = (control == 4'b0001);
    wire is_and  = (control == 4'b0010);
    wire is_or   = (control == 4'b0011);
    wire is_xor  = (control == 4'b0100);
    wire is_sll  = (control == 4'b0101);
    wire is_srl  = (control == 4'b0110);
    wire is_sra  = (control == 4'b0111);
    wire is_slt  = (control == 4'b1000);
    wire is_sltu = (control == 4'b1001);
    wire is_pass = (control == 4'b1010);

    wire use_adder = is_add || is_sub || is_slt || is_sltu;
    wire [63:0] B_mux = (is_sub || is_slt || is_sltu) ? ~B : B;
    wire        cin   = (is_sub || is_slt || is_sltu);
    wire [63:0] A_eff = use_adder ? A     : 64'd0;
    wire [63:0] B_eff = use_adder ? B_mux : 64'd0;
    wire        cin_eff = use_adder ? cin : 1'b0;
    wire [63:0] add_sum;
    wire        add_cout;

    adder_64 u_adder (
        .a(A_eff),
        .b(B_eff),
        .cin(cin_eff),
        .sum(add_sum),
        .cout(add_cout)
    );

    wire add_overflow = (A_eff[63] == B_eff[63]) && (add_sum[63] != A_eff[63]);
    wire sub_overflow = (A_eff[63] != B_eff[63]) && (add_sum[63] != A_eff[63]);
    always @(*) begin
        result   = 64'd0;
        flag     = 1'b0;
        overflow = 1'b0;
        case (control)
            4'b0000: begin                                                          // ADD
                result   = add_sum;
                flag     = add_cout;
                overflow = add_overflow;
            end
            4'b0001: begin                                                          // SUB
                result   = add_sum;                                                    
                flag     = add_cout;                                                // borrow = ~flag
                overflow = sub_overflow;
            end
            4'b0010: result = A & B;                                               // AND
            4'b0011: result = A | B;                                               // OR     
            4'b0100: result = A ^ B;                                               // XOR 
            4'b0101: result = A << B[5:0];                                         // SLL
            4'b0110: result = A >> B[5:0];                                         // SRL
            4'b0111: result = $signed(A) >>> B[5:0];                               // SRA
            4'b1000: begin                                                         // SLT (signed)
                result   = (sub_overflow ^ add_sum[63]) ? 64'd1 : 64'd0;
                overflow = sub_overflow;
            end
            4'b1001: begin                                                         // SLTU (unsigned)
                result = (~add_cout) ? 64'd1 : 64'd0;
            end
            4'b1010: result = B;                                                  // PASS (LUI)
            default: begin
                result = 64'd0;                                                  // safer for pipeline
            end
        endcase
    end
    assign Zero     = (result == 64'd0);
    assign Negative = result[63];                                               //NEGATIVE flag
endmodule


