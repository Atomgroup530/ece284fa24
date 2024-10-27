// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

// my code

input unsigned [bw-1:0] a;      // unsigned activation
input signed [bw-1:0] b;        // signed weight
input signed [psum_bw-1:0] c;   // signed psum
output signed [psum_bw-1:0] out;// signed output

wire signed [bw:0] a_ex;

assign a_ex = {1'b0,a};

assign out = c + a_ex * b;

endmodule
