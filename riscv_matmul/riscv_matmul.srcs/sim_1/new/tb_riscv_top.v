`timescale 1ns / 1ps

module tb_riscv_top();

  localparam CLK_PERIOD = 100;

  reg clk;
  reg rst;
  
  riscv_top riscv_top_dut (
    .clk (clk),
    .rst (rst)
  );
  
  initial begin
    clk = 1'b0;
  end
  
  always #(CLK_PERIOD / 2) clk = ~clk;
  
  initial begin
    rst = 1'b1;
    # (CLK_PERIOD * 2);
    
    rst = 1'b0;
    # (CLK_PERIOD * 50);
    
    $finish;
  end
  
  initial begin
    $dumpfile("waveform.vcd");  
    $dumpvars(0, riscv_top_dut);          
  end

endmodule
