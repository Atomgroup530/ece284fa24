// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_wrapper (clk, out, X0, X1, X2, X3, W0, W1, W2, W3, psum_in);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out;
input [bw-1:0] X0;
input [bw-1:0] X1;
input [bw-1:0] X2;
input [bw-1:0] X3;
input [bw-1:0] W0;
input [bw-1:0] W1;
input [bw-1:0] W2;
input [bw-1:0] W3;
input  [psum_bw-1:0] psum_in;
input  clk;

reg    [bw-1:0] X0_q;
reg    [bw-1:0] X1_q;
reg    [bw-1:0] X2_q;
reg    [bw-1:0] X3_q;
reg    [bw-1:0] W0_q;
reg    [bw-1:0] W1_q;
reg    [bw-1:0] W2_q;
reg    [bw-1:0] W3_q;
reg    [psum_bw-1:0] psum_in_q;

mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .X0(X0_q), 
        .X1(X1_q), 
        .X2(X2_q), 
        .X3(X3_q), 
        .W0(W0_q),
        .W1(W1_q),
        .W2(W2_q),
        .W3(W3_q),
        .psum_in(psum_in_q),
	.out(out)
); 

always @ (posedge clk) begin
        X0_q  <= X0;
        X1_q  <= X1;
        X2_q  <= X2;
        X3_q  <= X3;
        W0_q  <= W0;
        W1_q  <= W1;
        W2_q  <= W2;
        W3_q  <= W3;
        psum_in_q <= psum_in;
end

endmodule
