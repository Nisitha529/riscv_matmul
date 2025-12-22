`timescale 1ns / 1ps

module riscv_top(
  input clk,
  input rst
);

  wire [31 : 0] pc_out_wire;
  wire [31 : 0] pc_next_wire;
  wire [31 : 0] pc_wire;
  wire [31 : 0] decode_wire;
  wire [31 : 0] read_data1;
  wire [31 : 0] read_data2;
  wire [31 : 0] regtomux;
  wire [31 : 0] wb_wire;
  wire [31 : 0] branch_target;
  wire [31 : 0] immgen_wire;
  wire [31 : 0] muxtoalu;
  wire [31 : 0] read_data_wire;
  wire [31 : 0] wb_data_wire;
  
  wire          regwrite;
  wire          alu_src;
  wire          memread;
  wire          memwrite;
  wire          memtoreg;
  wire          branch;
  wire          zero;
  
  wire [1 : 0]  aluop_wire;
  wire [3 : 0]  alucontrol_wire;
  
  program_counter program_counter_01 (
    .clk             (clk),
    .rst             (rst),
    
    .pc_in           (pc_wire),
    .pc_out          (pc_out_wire)
  );
  
  pc_adder pc_adder_01 (
    .pc_in           (pc_wire),
    .pc_next         (pc_next_wire)
  );
  
  pc_mux pc_mux_01 (
    .pc_in           (pc_next_wire),
    .pc_branch       (branch_target),
    .pc_select       (branch & zero),
    
    .pc_out          (pc_wire)
  );
  
  instruction_memory instruction_memory_01 (
    .rst             (rst),
    .clk             (clk),
    
    .read_address    (pc_out_wire),
    
    .instruction_out (decode_wire)
  );
  
  register_file register_file_01 (
    .clk             (clk),
    .rst             (rst),
    
    .regwrite        (regwrite),
    .rs1             (decode_wire[19 : 15]),
    .rs2             (decode_wire[24 : 20]),
    .rd              (decode_wire[11 : 7]),
    .write_data      (wb_data_wire),
    
    .read_data1      (read_data1),
    .read_data2      (read_data2)
  );
  
  main_control_unit main_control_unit_01 (
    .opcode          (decode_wire[6 : 0]),
    
    .regwrite        (regwrite),
    .memread         (memread),
    .memwrite        (memwrite),
    .memtoreg        (memtoreg),
    .alusrc          (alusrc),
    .branch          (branch),
    .aluop           (aluop_wire)
  );
  
  alu_control alu_control_01 (
    .funct3          (decode_wire[14 : 12]),
    .funct7          (decode_wire[31 : 25]),
    .alu_op          (aluop_wire),
    
    .alu_control_out (alucontrol_wire)
  );
  
  alu alu_01 (
    .a               (read_data1),
    .b               (muxtoalu),
    .alu_control_in  (alucontrol_wire),
    
    .result          (wb_wire),
    .zero            (zero)
  );
  
  immediate_generator immediate_generator_01 (
    .instruction     (decode_wire),
    
    .imm_out         (immgen_wire)
  );
  
  mux_2to_1 mux_2to_1_01 (
    .input0          (regtomux),
    .input1          (immgen_wire),
    .select          (alusrc),
    
    .out             (muxtoalu)
  );
  
  mux_2to_1 mux_2to_1_02 (
    .input0          (wb_wire),
    .input1          (read_data_wire),
    .select          (memtoreg),
    
    .out             (wb_data_wire)
  );
  
  branch_adder branch_adder_01 (
    .pc              (pc_out_wire),
    .offset          (immgen_wire),
    
    .branch_target   (branch_target)
  );
  
  data_memory data_memory_01 (
    .clk             (clk),
    .rst             (rst),
    
    .memread         (memread),
    .memwrite        (memwrite),
    .address         (wb_wire),
    .write_data      (regtomux),
    
    .read_data       (read_data_wire)
  );
  
  assign regtomux = readdata2;

endmodule
