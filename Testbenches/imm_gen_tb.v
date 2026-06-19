`timescale 1ns/1ps
module imm_gen_tb;
    reg [31:0] instr;
    wire [63:0] imm;
    imm_gen uut (.instr(instr), .imm(imm));
    initial begin
        $dumpfile("imm_gen_tb.vcd");
        $dumpvars(0, imm_gen_tb);
        $monitor("t=%0t | instr=%h | imm=%h", $time, instr, imm);
        // I-type ADDI (imm = 0xFFF)
        instr = 32'b111111111111_00000_000_00001_0010011; #10;
        // S-type SW (imm = 0x123)
        instr = 32'b0000001_00001_00010_010_00011_0100011; #10;
        // B-type BEQ (imm = 0x100)
        instr = 32'b0000000_00001_00010_000_00011_1100011; #10;
        // U-type LUI (imm = 0xABCDE000)
        instr = 32'b10101011110011011110_00001_0110111; #10;
        // J-type JAL (imm = 0x800)
        instr = 32'b00000000000100000000_00001_1101111; #10;
        #20 $finish;
    end
endmodule
