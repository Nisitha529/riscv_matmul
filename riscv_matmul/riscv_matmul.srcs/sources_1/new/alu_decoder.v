`timescale 1ns / 1ps

module alu_decoder(
  input      [2 : 0] funct3,
  input              funct7,
  input              op5,
  input      [1 : 0] alu_op,
  
  output reg [2 : 0] alu_control
);

  wire [1 : 0] concat;
  
  assign concat = {op5, funct7};
  
  always @ (*) begin
    case (alu_op) 
      2'b00 : alu_control = 3'b000;
      2'b01 : alu_control = 3'b001;
      2'b10 : begin
        case (funct3) 
          3'b000 : begin
            if (concat == 2'b11) begin
              alu_control = 3'b001;
            end else begin
              alu_control = 3'b000;
            end
          end
          
          3'b010  : alu_control = 3'b101;
          3'b110  : alu_control = 3'b011;
          3'b111  : alu_control = 3'b010;
          
          default : alu_control = 3'b000;
        endcase
      end
      
      default : alu_control = 3'b000;
    endcase
  end

endmodule
