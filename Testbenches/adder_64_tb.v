`timescale 1ns/1ps

module adder_64_tb;
  reg  [63:0] a, b;
  reg         cin;
  wire [63:0] sum;
  wire        cout;

  // Instantiate the DUT
  adder_64 uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
  );

  initial begin
    // Dumpfile setup for GTKWave
    $dumpfile("adder_64_tb.vcd");
    $dumpvars(0, adder_64_tb);

    // Monitor signals
    $monitor("t=%0t | a=%h b=%h cin=%b -> sum=%h cout=%b",
              $time, a, b, cin, sum, cout);

    // Test vectors
    a   = 64'h0000_0000_0000_0000; b = 64'h0000_0000_0000_0000; cin = 0;
    #10 a = 64'h0000_0000_0000_0001; b = 64'h0000_0000_0000_0001; cin = 0;
    #10 a = 64'hFFFF_FFFF_FFFF_FFFF; b = 64'h0000_0000_0000_0001; cin = 0;
    #10 a = 64'h1234_5678_9ABC_DEF0; b = 64'hFEDC_BA98_7654_3210; cin = 1;
    #10 a = 64'hAAAA_AAAA_AAAA_AAAA; b = 64'h5555_5555_5555_5555; cin = 0;
    #10 a = 64'hFFFF_FFFF_FFFF_FFFF; b = 64'hFFFF_FFFF_FFFF_FFFF; cin = 1;

    #20 $finish;
  end
endmodule
