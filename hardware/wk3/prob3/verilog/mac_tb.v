// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg [bw-1:0] X0;
reg [bw-1:0] X1;
reg [bw-1:0] X2;
reg [bw-1:0] X3;
reg [bw-1:0] W0;
reg [bw-1:0] W1;
reg [bw-1:0] W2;
reg [bw-1:0] W3;
reg [psum_bw-1:0] psum_in;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec;
integer w_dec;
integer i; 
integer u; 

function [3:0] w_bin ;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction



function [3:0] x_bin ;

  // my code
  input integer activation ;
  begin
    
    if (activation>7) begin
      x_bin[3] = 1;
      activation = activation - 8;
    end
    else
      x_bin[3] = 0;

    if (activation>3) begin
     x_bin[2] = 1;
     activation = activation - 4;
    end
    else 
     x_bin[2] = 0;

    if (activation>1) begin
     x_bin[1] = 1;
     activation = activation - 2;
    end
    else 
     x_bin[1] = 0;

    if (activation>0) 
     x_bin[0] = 1;
    else 
     x_bin[0] = 0;

  end

endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
  
  input signed [bw:0] a;       // unsigned activation
  input signed [bw-1:0] b;        // signed weight
  input signed [bw:0] c;
  input signed [bw-1:0] d;
  input signed [bw:0] a_q;       // unsigned activation
  input signed [bw-1:0] b_q;        // signed weight
  input signed [bw:0] c_q;
  input signed [bw-1:0] d_q;
  input signed [psum_bw-1:0] psum;

  mac_predicted = a*b + c*d + a_q*b_q + c_q*d_q + psum;

endfunction



mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
      .X0(X0), 
      .X1(X1), 
      .X2(X2), 
      .X3(X3), 
      .W0(W0),
      .W1(W1),
      .W2(W2),
      .W3(W3),
      .psum_in(psum_in),
	.out(out)
); 
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<5; i=i+1) begin  // Data lenght is 10 in the data files

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);
     X0 = x_bin(x_dec); // unsigned number
     W0 = w_bin(w_dec); // signed number
     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);
     X1 = x_bin(x_dec); // unsigned number
     W1 = w_bin(w_dec); // signed number
     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);
     X2 = x_bin(x_dec); // unsigned number
     W2 = w_bin(w_dec); // signed number
     w_scan_file = $fscanf(w_file, "%d\n", w_dec);
     x_scan_file = $fscanf(x_file, "%d\n", x_dec);
     X3 = x_bin(x_dec); // unsigned number
     W3 = w_bin(w_dec); // signed number
     psum_in = expected_out;

     expected_out = mac_predicted(X0, W0, X1, W1, X2, W2, X3, W3, psum_in);

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




