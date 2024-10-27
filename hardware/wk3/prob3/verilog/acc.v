module acc (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

// my code

input signed [2*bw:0] a;      // unsigned activation
input signed [2*bw:0] b;        // signed weight
input signed [psum_bw-1:0] c;   // signed psum
output signed [psum_bw-1:0] out;// signed output

assign out = a + b + c;

endmodule