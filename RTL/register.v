module register(clk, rst, write_enable, data_in, data_out);

input clk, rst, write_enable;
input [63:0] data_in;
output reg [63:0] data_out;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 64'b0;
    end else if (write_enable) begin
        data_out <= data_in;
    end
end

endmodule