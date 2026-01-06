`timescale 1ns / 1ps

module tb_riscv_core_top();

  localparam CLK_PERIOD = 10;

  reg clk;
  reg rst;

  riscv_core_top riscv_core_top_dut (
    .clk (clk),
    .rst (rst)
  );
  
  initial begin
    clk = 0;
    
    forever # (CLK_PERIOD / 2) clk = ~clk;
    
  end
  
  initial begin
    rst = 1;
    # (CLK_PERIOD * 4);
    rst = 0;
    
    # (CLK_PERIOD * 160);
    $finish;
  end

endmodule
