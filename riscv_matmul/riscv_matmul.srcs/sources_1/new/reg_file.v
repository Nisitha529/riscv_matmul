`timescale 1ns / 1ps

module reg_file # (
  parameter DATA_WIDTH    = 32,
  parameter ADDRESS_WIDTH = 5
)(
  input                          clk,
  input                          rst,
  
  input  [ADDRESS_WIDTH - 1 : 0] a1,
  input  [ADDRESS_WIDTH - 1 : 0] a2,
  input  [ADDRESS_WIDTH - 1 : 0] a3,
  
  input                          we3,
  input  [DATA_WIDTH - 1 : 0]    wd3,
  
  output [DATA_WIDTH - 1 : 0]    rd1,
  output [DATA_WIDTH - 1 : 0]    rd2
);

  parameter DEPTH = (2 ** ADDRESS_WIDTH) - 1;
  
  reg [DATA_WIDTH - 1 : 0] reg_file [0 : 31];
  
  integer i;
  
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < (2 ** ADDRESS_WIDTH); i = i + 1)
        reg_file [i] <= 32'd0;
    end else if (we3) 
      reg_file [a3]  <= wd3;
  end
  
  assign rd1 = reg_file [a1];
  assign rd2 = reg_file [a2];

endmodule
