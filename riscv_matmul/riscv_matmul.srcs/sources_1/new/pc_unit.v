`timescale 1ns / 1ps

module pc_unit(
  input               clk,
  input               rst,
  
  input               stall,
  input      [31 : 0] pc_next,
  
  output reg [31 : 0] pc
);

  always @ (posedge clk, posedge rst) begin
    if (rst) begin
      pc <= 32'd0;
    end else if (!stall) begin
      pc <= pc_next;
    end
  end

endmodule
