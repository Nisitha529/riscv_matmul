`timescale 1ns / 1ps

module pc_adder(
  input  [31 : 0] pc_in,
  
  output [31 : 0] pc_next
);

//  always @(*) begin
//    pc_next = pc_in + 32'd4;
//  end

  assign pc_next = pc_in + 32'd4;

endmodule
