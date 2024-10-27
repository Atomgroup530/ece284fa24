// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [bw-1:0] a;
reg  [bw-1:0] b;
reg  [bw-1:0] c;
reg  [bw-1:0] d;
reg  [psum_bw-1:0] psum;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer Aa_dec, Ac_dec;
integer Wb_dec, Wd_dec;
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


reg out_high=0;
reg compare_high=0;

mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
        .a(a), 
        .b(b),
        .c(c),
        .d(d),
        .psum(psum),
        .out_high(out_high),
	.out(out)
); 
 
reg  [bw-1:0] a_q;
reg  [bw-1:0] b_q;
reg  [bw-1:0] c_q;
reg  [bw-1:0] d_q;

reg signed [psum_bw-1:0] out_print;
reg signed [psum_bw-1:0] expected_print;



initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<10; i=i+1) begin  // Data lenght is 10 in the data files

     #1 clk = 1'b1;
     if (compare_high && i > 2) begin
      if (expected_print == out_print) $display("Output match\n");
      else $display("Output don't match, expected=%d, out=%d\n", expected_print, out_print);
     end
     #1 clk = 1'b0;

     w_scan_file = $fscanf(w_file, "%d\n", Wb_dec);
     w_scan_file = $fscanf(w_file, "%d\n", Wd_dec);
     x_scan_file = $fscanf(x_file, "%d\n", Aa_dec);
     x_scan_file = $fscanf(x_file, "%d\n", Ac_dec);

     a = x_bin(Aa_dec); // unsigned number
     b = w_bin(Wb_dec); // signed number
     c = x_bin(Ac_dec);
     d = w_bin(Wd_dec);
     psum = expected_out;
     out_print = out;
     expected_print = expected_out;

    //  $display("a=%d, b=%d, c=%d, d=%d, mid=%d, psum=%d, expected=%d", Aa_dec, Wb_dec, Ac_dec, Wd_dec, Aa_dec*Wb_dec+Ac_dec*Wd_dec, psum_print, expected_print);


     if (i%2 == 0) begin
      a_q = a;
      b_q = b;
      c_q = c;
      d_q = d;
      out_high = 0;
      compare_high = 0;
     end
     else begin
      expected_out = mac_predicted(a, b, c, d, a_q, b_q, c_q, d_q, psum);
      out_high = 1;
      compare_high = 1;
     end
  end

  compare_high = 1;

  for (i=10; i < 12; i=i+1) begin
    #1 clk = 1'b1;
    if (compare_high) begin
      if (expected_print == out_print) $display("Output match\n");
      else $display("Output don't match, expected=%d, out=%d\n", expected_print, out_print);
    end
    #1 clk = 1'b0;
    out_high = 0;
    out_print = out;
    expected_print = expected_out;
  end

  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule




