`timescale 1ns / 1ps

module alu_control(
  input      [2 : 0] funct3,
  input      [6 : 0] funct7,
  input      [1 : 0] alu_op,
  
  output reg [3 : 0] alu_control_out
);

//  always @ (*) begin
//    case ({alu_op, funct7, funct3})
//    12'b10_0000000_000 : alu_control_out <= 4'b0000; // ADD 
//    12'b00_0000000_000 : alu_control_out <= 4'b0000; // ADD 
//    12'b00_0000000_001 : alu_control_out <= 4'b0000; // ADD 
//    12'b00_0000000_010 : alu_control_out <= 4'b0000; // ADD 
//    12'b10_0100000_000 : alu_control_out <= 4'b0001; // SUB 
//    12'b10_0000000_111 : alu_control_out <= 4'b0010; // AND
//    12'b10_0000000_110 : alu_control_out <= 4'b0011; // OR
//    12'b10_0000000_100 : alu_control_out <= 4'b0100; // XOR
//    12'b10_0000000_001 : alu_control_out <= 4'b0101; // SLL
//    12'b10_0000000_101 : alu_control_out <= 4'b0110; // SRL
//    12'b10_0100000_101 : alu_control_out <= 4'b0111; // SRA
//    12'b10_0000000_010 : alu_control_out <= 4'b1000; // SLT
//    default            : alu_control_out <= 4'b0000; 
//    endcase
//  end

  reg [9:0] fn;
  
  always @(*) begin
    fn = {funct7[6:0], funct3}; // 7 + 3 -> 10 bits (we will inspect)
    
    case (alu_op)
      2'b00 : alu_control_out = 4'b0000; // ADD for loads/stores/AUIPC/JAL/JALR default
      
      2'b01 : begin // Branches (funct3 decides)
        case (funct3)
          3'b000  : alu_control_out = 4'b0001; // BEQ/BNE -> subtract
          3'b001  : alu_control_out = 4'b0001; // BNE -> subtract too
          3'b100  : alu_control_out = 4'b1000; // BLT -> SLT
          3'b101  : alu_control_out = 4'b1000; // BGE -> SLT (ALU checks result)
          3'b110  : alu_control_out = 4'b1001; // BLTU -> SLTU
          3'b111  : alu_control_out = 4'b1001; // BGEU -> SLTU
          default : alu_control_out = 4'b0001;
          
        endcase
      end
         
      2'b10 : begin
        case ({funct7[5], funct3})   
                      
          {1'b0, 3'b000} : alu_control_out = 4'b0000; // ADD/ADDI
          {1'b1, 3'b000} : alu_control_out = 4'b0001; // SUB
          {1'b0, 3'b100} : alu_control_out = 4'b0100; // XOR
          {1'b0, 3'b110} : alu_control_out = 4'b0011; // OR
          {1'b0, 3'b111} : alu_control_out = 4'b0010; // AND
          {1'b0, 3'b001} : alu_control_out = 4'b0101; // SLL
          {1'b0, 3'b101} : alu_control_out = 4'b0110; // SRL (funct7[5]=0)
          {1'b1, 3'b101} : alu_control_out = 4'b0111; // SRA (funct7[5]=1)
          {1'b0, 3'b010} : alu_control_out = 4'b1000; // SLT
          {1'b0, 3'b011} : alu_control_out = 4'b1001; // SLTU
          
          default :        alu_control_out = 4'b0000;
        endcase
      end
      
      2'b11  : alu_control_out = 4'b1100; // LUI
  
      default: alu_control_out = 4'b0000;
    endcase
  end

endmodule
