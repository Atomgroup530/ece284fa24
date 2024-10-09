// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, A, B, format, acc, clk, reset);

parameter bw = 8;
parameter psum_bw = 16;

input clk;
input acc;
input reset;
input format;

input signed [bw-1:0] A;
input signed [bw-1:0] B;

output signed [psum_bw-1:0] out;

reg signed [psum_bw-1:0] psum_q;
reg signed [bw-1:0] a_q;
reg signed [bw-1:0] b_q;

assign out = psum_q;

// Your code goes here
// Path: /home/linux/ieng6/ee284fa24/xul007/hardware/wk1/hw1
wire [psum_bw-1:0] result0;
wire [psum_bw-1:0] result1;

assign result0 = psum_q+a_q*b_q;

wire prod_sign, psum_q_sign;
wire [psum_bw-2:0] prod_mag;
wire [psum_bw-2:0] psum_q_mag;

assign prod_sign = a_q[bw-1] ^ b_q[bw-1];
assign prod_mag = a_q[bw-2:0] * b_q[bw-2:0];
assign psum_q_sign = psum_q[psum_bw-1];
assign psum_q_mag = psum_q[psum_bw-2:0];
assign result1 = (prod_sign ^ psum_q_sign)? (
                     (prod_mag == psum_q_mag)? 0
                     : (prod_mag > psum_q_mag)? {prod_sign,(prod_mag-psum_q_mag)}
                     : {psum_q_sign, (psum_q_mag-prod_mag)}
                  ) : {prod_sign,(prod_mag+psum_q_mag)};

always @(posedge clk) begin
   a_q <= A;
   b_q <= B;

   if (reset) begin
      psum_q <= 0;
   end else begin
      if (acc) begin
         psum_q <= (format)? result1 : result0;
      end
   end

end


endmodule
