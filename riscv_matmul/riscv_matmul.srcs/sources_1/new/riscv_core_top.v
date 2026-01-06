`timescale 1ns / 1ps

module riscv_core_top(
  input clk,
  input rst
);

  wire [31 : 0] pc_out;
  wire [31 : 0] pc_seq;
  wire [31 : 0] pc_branch;
  wire [31 : 0] pc_next;
  
  wire [31 : 0] instr;
  
  wire [31 : 0] reg_read1;
  wire [31 : 0] reg_read2;
  
  wire [31 : 0] imm;
  
  wire [31 : 0] alu_in_b;
  wire [31 : 0] alu_result;
  
  wire [31 : 0] mem_read_data;
  wire [31 : 0] wb_data;
  
  wire          zero_flag;
  wire          pc_src;
  
  wire          regwrite;
  wire          memread;
  wire          memwrite;
  wire          memtoreg;
  wire          alusrc;
  wire          branch;
  
  wire [1 : 0]  aluop;
  wire [3 : 0]  alucontrol;
  
  wire [6 : 0]  opcode        = instr [6 : 0];
  wire [4 : 0]  rd            = instr [11 : 7];
  wire [2 : 0]  funct3        = instr [14 : 12];
  wire [4 : 0]  rs1           = instr [19 : 15];
  wire [4 : 0]  rs2           = instr [24 : 20];
  wire [6 : 0]  funct7        = instr [31 : 25];
  
  wire          is_jal        = (opcode == 7'b1101111);
  wire          is_jalr       = (opcode == 7'b1100111);
  
  wire [31 : 0] jal_target    = pc_seq + imm;
  wire [31 : 0] jalr_target   = {(reg_read1 + imm) & 32'hfffffffe};
  
  wire [31 : 0] chosen_target = is_jal ? jal_target : (is_jalr ? jalr_target : pc_branch);
  
  wire [31 : 0] pc_plus4      = pc_next;
  
  wire [31 : 0] final_wb      = (is_jal | is_jalr) ? pc_plus4 : wb_data;
  
  assign pc_src = (branch & zero_flag) | is_jal | is_jalr;
  
  program_counter program_counter_01 (
    .clk             (clk),
    .rst             (rst),
    
    .pc_in           (pc_out),
    
    .pc_out          (pc_seq)
  );
  
  pc_adder pc_adder_01 (
    .pc_in           (pc_seq),
    .pc_next         (pc_next)
  );
  
  branch_adder branch_adder_01 (
    .pc              (pc_seq),
    .offset          (imm),
    
    .branch_target   (pc_branch)
  );
  
  program_memory program_memory_01 (
    .read_address    (pc_seq),
    
    .instruction_out (instr)
  );
  
  main_control_unit main_control_unit_01 (
    .opcode          (opcode),
    
    .regwrite        (regwrite),
    .memread         (memread),
    .memwrite        (memwrite),
    .memtoreg        (memtoreg),
    .alusrc          (alusrc),
    .branch          (branch),
    .aluop           (aluop)
  );
  
  immediate_generator immediate_generator_01 (
    .instruction     (instr),
    
    .imm_out         (imm)
  );
  
  register_file register_file_01 (
    .clk             (clk),
    .rst             (rst),
    
    .regwrite        (regwrite),
    .rs1             (rs1),
    .rs2             (rs2),
    .rd              (rd),
    .write_data      (wb_data),
    
    .read_data1      (reg_read1),
    .read_data2      (reg_read2)
  );
  
  alu_control alu_control_01 (
    .funct3          (funct3),
    .funct7          (funct7),
    .alu_op          (aluop),
    
    .alu_control_out (alucontrol)
  );
  
  mux_2to_1 mux_2to_1_01 (
    .input0          (reg_read2),
    .input1          (imm),
    .select          (alusrc),
    
    .out             (alu_in_b)
  );
  
  alu alu_01 (
    .a               (reg_read1),
    .b               (alu_in_b),
    .alu_control_in  (alucontrol),
    
    .result          (alu_result),
    .zero            (zero_flag)
  );
  
  data_memory data_memory_01 (
    .clk             (clk),
    .rst             (rst),
    
    .memread         (memread),
    .memwrite        (memwrite),
    .memop           (funct3),
    .address         (alu_result),
    .write_data      (reg_read2),
    
    .read_data       (mem_read_data)
  );
  
  mux_2to_1 mux_2to_1_02 (
    .input0          (alu_result),
    .input1          (mem_read_data),
    .select          (memtoreg),
    
    .out             (wb_data)
  );
  
  pc_mux pc_mux_01 (
    .pc_seq          (pc_next),
    .pc_branch       (chosen_target),
    .pc_select       (pc_src),
    
    .pc_out          (pc_out)
  );
  
endmodule
