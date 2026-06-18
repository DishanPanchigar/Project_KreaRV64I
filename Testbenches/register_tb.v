module register_tb;
reg clk, rst, write_enable;
reg [63:0] data_in;
wire [63:0] data_out;
register reg1(clk, rst, write_enable, data_in, data_out);
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
initial begin
    $monitor("time=%0t | data_in=%h | data_out=%h", $time, data_in, data_out);

    rst = 1;
    write_enable = 0;
    data_in = 64'h1234567890abcdef;

    #10 rst = 0;
    #10 write_enable = 1;
    #10 write_enable = 0;
    #10 $finish;
end
initial begin
    $dumpfile("register_tb.vcd");
    $dumpvars(0, register_tb);
end
endmodule