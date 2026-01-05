`timescale 1ns / 1ps

module instruction_mem(
  input      [31 : 0] a,

  output reg [31 : 0] rd
);

  localparam DEPTH = (2 ** 32) - 1;
  
  reg [31 : 0] mem [0 : 10000];
  
  initial begin
    $readmemh ("/media/nisitha/My_Passport/MOODLE/Vivado_projects/riscv_matmul/riscv_matmul/riscv_matmul.srcs/sources_1/new/test_riscv.txt", mem);
  end
  
  always @ (*) begin
    rd = mem [a >> 2];
  end

endmodule
