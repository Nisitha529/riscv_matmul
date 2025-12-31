`timescale 1ns / 1ps

module top_riscv(
  input           clk,
  input           reset,
  
  output [31 : 0] write_data_test,
  output [31 : 0] data_adr_test,
  
  output          memwrite_test,
  output          read_data_test,
  output          readdata_test
);

  wire [31 : 0] pc_i;
  wire [31 : 0] instr_i;
  wire [31 : 0] pcnext_i;
  wire [31 : 0] result_i;
  wire [31 : 0] srca_i;
  wire [31 : 0] srcb_i;
  wire [31 : 0] rd2_i;
  wire [31 : 0] immext_i;
  wire [31 : 0] pctarget_i;
  wire [31 : 0] aluresult_i;
  wire [31 : 0] readdata_i;
  wire [31 : 0] pcplus4_i;
  
  wire [2 : 0]  alucontrol_i;
  
  wire [1 : 0]  resultsrc_i;
  wire [1 : 0]  immsrc_i;
  
  wire          regwrite_i;
  wire          zero_i;
  wire          memwrite_i;
  wire          alusrc_i;
  wire          pcsrc_i;
  wire          stall_i;
  wire          read_data;   
  
  assign write_data_test = rd2_i;
  assign data_adr_test   = aluresult_i;
  
  assign memwrite_test   = memwrite_i;
  assign read_data_test  = read_data;
  assign readdata_test   = readdata_i;
  
  pc_unit pc_unit_01 (
    .clk         (clk),
    .rst         (reset),
    
    .stall       (stall_i),
    .pc_next     (pcnext_i),
    
    .pc          (pc_i)
  );  
  
  instruction_mem instruction_mem_01 (
    .a           (pc_i),
    
    .rd          (instr_i)
  );     
  
  reg_file reg_file_01 (
    .clk         (clk),
    .rst         (reset),
    
    .a1          (instr_i [19 : 15]),
    .a2          (instr_i [24 : 20]),
    .a3          (instr_i [11 : 7]),
    
    .we3         (regwrite_i),
    .wd3         (result_i),
    
    .rd1         (srca_i),
    .rd2         (srcb_i)
  );
  
  control_unit control_unit_01 (
    .funct3      (instr_i [ 14 : 12]),
    .funct7      (instr_i [30]),
    .op          (instr_i [6 : 0]),
    .zero        (zero_i),
    
    .mem_write   (memwrite_i),
    .result_src  (resultsrc_i),
    .alu_src     (alusrc_i),
    .imm_src     (immsrc_i),
    .reg_write   (regwrite_i),
    .alu_control (alucontrol_i),
    .pcsrc       (pcsrc_i)
  );
  
  sign_extend sign_extend_01 (
    .instr       (instr_i [31 : 7]),
    .imm_src     (immsrc_i),
    
    .imm_ext     (immext_i)
  );
  
  mux_2x1 mux_2x1_01 (
    .d0          (rd2_i),
    .d1          (immext_i),
    .s           (alusrc_i),
    
    .y           (srcb_i)
  );
  
  mux_2x1 mux_2x1_02 (
    .d0          (pcplus4_i),
    .d1          (pctarget_i),
    .s           (pcsrc_i),
    
    .y           (pcnext_i)
  );
  
  adder adder_0 (
    .a           (pc_i),
    .b           (immext_i),
    
    .c           (pctarget_i)
  );
  
  adder adder_1 (
    .a           (pc_i),
    .b           (32'd4),
    
    .c           (pcplus4_i)
  );
  
  alu_unit alu_unit_01 (
    .src_a       (srca_i),
    .src_b       (srcb_i),
    .alu_control (alucontrol_i),
    
    .alu_result  (aluresult_i),
    .zero        (zero)
  );
  
  mux_3x1 mux_3x1_01 (
    .data_0      (aluresult_i),
    .data_1      (readdata_i),
    .data_2      (pcplus4_i),
    .select      (resultsrc_i),
    
    .out         (result_i)
  );
  
  assign read_data = (instr_i [6 : 0] == 7'b0000011) ? 1'b1 : 1'b0;

endmodule
