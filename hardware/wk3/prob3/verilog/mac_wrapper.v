// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, out, a, b, c, d, psum);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input  [bw-1:0] a;
input  [bw-1:0] b;
input  [bw-1:0] c;
input  [bw-1:0] d;
input  [psum_bw-1:0] psum;

input  clk;

reg    [bw-1:0] a_q;
reg    [bw-1:0] b_q;
reg    [bw-1:0] c_q;
reg    [bw-1:0] d_q;
wire   [2*bw:0] mid;
reg    [2*bw:0] mid_q;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .a(a_q), 
        .b(b_q),
        .c(c_q),
        .d(d_q),
	.out(mid)
); 

acc #(.bw(bw), .psum_bw(psum_bw)) acc_instance (
        .a(mid_q),
        .b(mid),
        .c(psum),
        .out(out)
);

always @ (posedge clk) begin
        b_q  <= b;
        a_q  <= a;
        c_q  <= c;
        d_q  <= d;
        mid_q <= mid;
end

endmodule
