`timescale 1ns / 1ps

module branch_adder(
  input      [31 : 0] pc,
  input      [31 : 0] offset,
  
  output reg [31 : 0] branch_target
);

  always @ (*) begin
    branch_target <= pc + offset;
  end

endmodule
