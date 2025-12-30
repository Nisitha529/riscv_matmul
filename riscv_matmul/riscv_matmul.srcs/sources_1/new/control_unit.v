`timescale 1ns / 1ps

module control_unit #(
  parameter WIDTH = 7
)(
  input  [2 : 0]         funct3,
  input                  funct7,
  input  [WIDTH - 1 : 0] op,
  input                  zero,
  
  output                 mem_write,
  output [1 : 0]         result_src,
  output                 alu_src,
  output [1 : 0]         imm_src,
  output                 reg_write,
  output [2 : 0]         alu_control,
  output                 pc_src 
);

  wire [1 : 0] alu_op;
  wire         jump;
  wire         branch;
  
  assign pc_src = (zero & branch) | jump;
  
  main_decoder main_decoder_01 (
    .opcode      (op),
    
    .branch      (branch),
    .jump        (jump),
    .result_src  (result_src),
    .mem_write   (mem_write),
    .alu_src     (alu_src),
    .imm_src     (imm_src),
    .reg_write   (reg_write),
    .alu_op      (alu_op)
  );
  
  alu_decoder alu_decoder_01 (
    .funct3      (funct3),
    .funct7      (funct7),
    .op5         (op[5]),
    .alu_op      (alu_op),
    .alu_control (alu_control)
  );

endmodule
