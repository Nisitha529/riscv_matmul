`timescale 1ns / 1ps

module pc_mux(
  input  [31 : 0] pc_seq,
  input  [31 : 0] pc_branch,
  input           pc_select,
  
  output [31 : 0] pc_out
);

//  always @(*) begin
//    if (pc_select == 1'b0 ) begin
//      pc_out = pc_seq;
//    end else begin
//      pc_out = pc_branch;
//    end
//  end

  assign pc_out = pc_select ? pc_branch : pc_seq;

endmodule
