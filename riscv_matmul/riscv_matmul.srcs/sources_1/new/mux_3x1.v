`timescale 1ns / 1ps

module mux_3x1(
  input  [31 : 0] data_0,
  input  [31 : 0] data_1,
  input  [31 : 0] data_2,
  input  [1 : 0]  select,
  
  output [31 : 0] out
);

  assign out = (select == 2'b00) ? data_0 : 
               (select == 2'b01) ? data_1 :
               (select == 2'b10) ? data_2 :
               32'd0;

endmodule
