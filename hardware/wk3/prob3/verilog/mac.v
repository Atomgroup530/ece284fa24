// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c, d);

parameter bw = 4;
parameter psum_bw = 16;

// my code

input unsigned [bw-1:0] a;      // unsigned activation
input signed [bw-1:0] b;        // signed weight
input signed [bw-1:0] c; 
input signed [bw-1:0] d; 
output signed [2*bw:0] out;// signed output

wire signed [bw:0] a_ex;
wire signed [bw:0] c_ex;

assign a_ex = {1'b0,a};
assign c_ex = {1'b0,c};

assign out = c_ex * d + a_ex * b;

endmodule
