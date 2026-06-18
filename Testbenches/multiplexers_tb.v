`timescale 1ns/1ps
module multiplexers_tb;
    reg a, b, sel2;
    wire y2;

    reg [3:0] d4;
    reg [1:0] sel4;
    wire y4;

    reg [7:0] d8;
    reg [2:0] sel8;
    wire y8;

    mux_2x1 uut2 (
        .a(a),
        .b(b),
        .sel(sel2),
        .y(y2)
    );

    mux_4x1 uut4 (
        .d(d4),
        .sel(sel4),
        .y(y4)
    );

    mux_8x1 uut8 (
        .d(d8),
        .sel(sel8),
        .y(y8)
    );

    initial begin
        $dumpfile("multiplexers_tb.vcd");
        $dumpvars(0, multiplexers_tb);

        $monitor("t=%0t | mux2: a=%b b=%b sel=%b y=%b | mux4: d=%b sel=%b y=%b | mux8: d=%b sel=%b y=%b",
                 $time, a, b, sel2, y2, d4, sel4, y4, d8, sel8, y8);

        a = 0; b = 1; sel2 = 0; #10;
        sel2 = 1; #10;
        a = 1; b = 0; sel2 = 0; #10;
        sel2 = 1; #10;

        d4 = 4'b1010;
        sel4 = 2'b00; #10;
        sel4 = 2'b01; #10;
        sel4 = 2'b10; #10;
        sel4 = 2'b11; #10;

        d8 = 8'b11001010;
        sel8 = 3'b000; #10;
        sel8 = 3'b001; #10;
        sel8 = 3'b010; #10;
        sel8 = 3'b011; #10;
        sel8 = 3'b100; #10;
        sel8 = 3'b101; #10;
        sel8 = 3'b110; #10;
        sel8 = 3'b111; #10;

        $display("===== TEST COMPLETE =====");
        $finish;
    end

endmodule
