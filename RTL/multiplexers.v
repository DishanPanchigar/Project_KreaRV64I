module mux_2x1 (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
    assign y = sel ? b : a;
endmodule

module mux_4x1 (
    input  wire [3:0] d,   
    input  wire [1:0] sel, 
    output reg  y
);
    always @(*) begin
        case (sel)
            2'b00: y = d[0];
            2'b01: y = d[1];
            2'b10: y = d[2];
            2'b11: y = d[3];
        endcase
    end
endmodule

module mux_8x1 (
    input  wire [7:0] d,  
    input  wire [2:0] sel,
    output reg  y
);
    always @(*) begin
        case (sel)
            3'b000: y = d[0];
            3'b001: y = d[1];
            3'b010: y = d[2];
            3'b011: y = d[3];
            3'b100: y = d[4];
            3'b101: y = d[5];
            3'b110: y = d[6];
            3'b111: y = d[7];
        endcase
    end
endmodule

