// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, X0, X1, X2, X3, W0, W1, W2, W3, psum_in);

parameter bw = 4;
parameter psum_bw = 16;

// my code

input unsigned [bw-1:0] X0;      // unsigned activation
input unsigned [bw-1:0] X1;      // unsigned activation
input unsigned [bw-1:0] X2;      // unsigned activation
input unsigned [bw-1:0] X3;      // unsigned activation
input signed [bw-1:0] W0;        // signed weight
input signed [bw-1:0] W1;        // signed weight
input signed [bw-1:0] W2;        // signed weight
input signed [bw-1:0] W3;        // signed weight
input signed [psum_bw-1:0] psum_in;   // signed psum
output signed [psum_bw-1:0] out;// signed output

wire signed [bw:0] X0_ex;
wire signed [bw:0] X1_ex;
wire signed [bw:0] X2_ex;
wire signed [bw:0] X3_ex;

wire signed [2*bw:0] acc0;
wire signed [2*bw:0] acc1;

assign X0_ex = {1'b0,X0};
assign X1_ex = {1'b0,X1};
assign X2_ex = {1'b0,X2};
assign X3_ex = {1'b0,X3};

assign acc0 = X0_ex*W0 + X1_ex*W1;
assign acc1 = X2_ex*W2 + X3_ex*W3;

assign out = acc0 + acc1 + psum_in;

endmodule
