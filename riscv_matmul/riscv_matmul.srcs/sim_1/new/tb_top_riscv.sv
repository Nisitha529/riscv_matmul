`timescale 1ns / 1ps

module tb_top_riscv();

  localparam CLK_PERIOD = 10;

  logic          clk;
  logic          reset;
 
  logic [31 : 0] writedata;
  logic [31 : 0] dataadr;

  logic          memwrite;
  logic          read_data;
  logic          readdata;

  top_riscv top_riscv_dut(
    .clk_i           (clk), 
    .reset_i         (reset),
 
    .write_data_test (writedata), 
    .data_adr_test   (dataadr),

    .memwrite_test   (memwrite),
    .read_data_test  (read_data),
    .readdata_test   (readdata)
  );

  initial begin
    reset <= 1; 
    # (CLK_PERIOD * 3); 
    reset <= 0; 
  end

  always begin
    clk <= 1; 
    # (CLK_PERIOD / 2);
    clk <= 0; 
    # (CLK_PERIOD / 2);
  end
 
  always @(negedge clk) begin
    if(memwrite) begin
	  if(dataadr == 'd50 && writedata == 32'hfffff8ae) begin
	    # 50
		$display("Simulation succeeded");
		$stop;
	  end else if (dataadr == 'd50 && writedata != 32'hfffff8ae) begin
		$display("Simulation failed");
		$stop;
	  end
	end
  end
  
endmodule