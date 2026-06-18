module adder_4( //CLA
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire [3:0] p, g;
    wire [4:0] c;
    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) 
                        | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) 
                        | (p[2] & p[1] & g[0]) 
                        | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) 
                        | (p[3] & p[2] & g[1]) 
                        | (p[3] & p[2] & p[1] & g[0]) 
                        | (p[3] & p[2] & p[1] & p[0] & c[0]);
    assign sum  = p ^ c[3:0];
    assign cout = c[4];
endmodule

module adder_64 ( //CLA
    input  [63:0] a,
    input  [63:0] b,
    input         cin,
    output [63:0] sum,
    output        cout
);
    wire [15:0] carry;

    adder_4 block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for(i = 1; i < 16; i = i + 1) begin: cs_block
            wire [3:0] sum0, sum1;
            wire cout0, cout1;
            adder_4 add0 (
                .a(a[i*4+3:i*4]),
                .b(b[i*4+3:i*4]),
                .cin(1'b0),
                .sum(sum0),
                .cout(cout0)
            );
            adder_4 add1 (
                .a(a[i*4+3:i*4]),
                .b(b[i*4+3:i*4]),
                .cin(1'b1),
                .sum(sum1),
                .cout(cout1)
            );
            assign sum[i*4+3:i*4] = carry[i-1] ? sum1 : sum0;
            assign carry[i]       = carry[i-1] ? cout1 : cout0;
        end
    endgenerate
    assign cout = carry[15];
endmodule