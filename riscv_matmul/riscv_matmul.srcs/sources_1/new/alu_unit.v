`timescale 1ns / 1ps

module alu_unit(
  input      [31 : 0] src_a,
  input      [31 : 0] src_b,
  input      [2 : 0]  alu_control,
  
  output reg [31 : 0] alu_result,
  output reg          zero
);

  always @ (*) begin
    case (alu_control) 
      3'b000 : alu_result = src_a + src_b;
      3'b001 : alu_result = src_a - src_b;
      3'b010 : alu_result = src_a & src_b;
      3'b011 : alu_result = src_a | src_b;
      3'b101 : begin
        if (src_a < src_b) begin
          alu_result = 32'd1;
        end else begin
          alu_result = 32'd0;
        end
      end
      
      default : alu_result = 32'd0;
    endcase
    
    zero = ~| (alu_result);
  end

endmodule