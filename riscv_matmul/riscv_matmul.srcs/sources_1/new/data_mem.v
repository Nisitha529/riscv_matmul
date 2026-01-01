`timescale 1ns / 1ps

module data_mem #(
  parameter DATA_WIDTH      = 32,
  parameter MISS_DATA_WIDTH = 128,
  parameter ADDRESS_WIDTH   = 10,
  parameter MEM_DEPTH       = 1024
)(
  input                                clk,
  input                                reset,
  
  input                                write,
  input                                read,
  input      [DATA_WIDTH - 1 : 0]      wdata,
  input      [ADDRESS_WIDTH - 1 : 0]   addr,
  
  output reg [MISS_DATA_WIDTH - 1 : 0] miss_mm_data,
  output reg                           ready
);

  integer i;
  
  reg [DATA_WIDTH - 1 : 0] data_ram [0 : MEM_DEPTH - 1];
  reg [1 : 0]              counter;
  
  always @ (*) begin
    if (read) begin
      miss_mm_data = {data_ram[{addr[ADDRESS_WIDTH - 1 : 2], 2'b11}], data_ram[{addr[ADDRESS_WIDTH - 1 : 2], 2'b10}], data_ram[{addr[ADDRESS_WIDTH - 1 : 2], 2'b01}], data_ram[{addr[ADDRESS_WIDTH - 1 : 2], 2'b00}]};
    end else begin
      miss_mm_data = {MISS_DATA_WIDTH{1'b0}};
    end
  end
  
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      for (i = 0; i < MEM_DEPTH; i = i + 1) begin
        data_ram [i] <= 32'd0;
      end
      ready          <= 1'd0;
      counter        <= 2'd0;
    end else if (read) begin
      ready          <= 1'b0;
      counter        <= counter + 1'b1;
      if (counter == 2'b11) begin
        ready        <= 1'b1;
        counter      <= 2'd0;
      end else begin
        ready        <= 1'b0;
      end
    end else if (write) begin
      ready          <= 1'b0;
      data_ram[addr] <= wdata;
      counter        <= counter + 1'b1;
      if (counter == 2'b11) begin
        ready        <= 1'b1;
        counter      <= 2'd0;
      end else begin
        ready        <= 1'b0;
      end
    end else begin
      ready          <= 1'b0;
    end
  end

endmodule
