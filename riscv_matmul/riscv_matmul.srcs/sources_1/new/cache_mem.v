`timescale 1ns / 1ps

module cache_mem #(
  parameter DATA_WIDTH      = 32,
  parameter MISS_DATA_WIDTH = 128,
  parameter ADDRESS_WIDTH   = 7,
  parameter CACHE_DEPTH     = 128
)(
  input                                clk,
  input                                reset,
  
  input                                refill,
  input                                update,
  
  input                                read,
  input      [DATA_WIDTH - 1 : 0]      wdata,  
  
  input      [MISS_DATA_WIDTH - 1 : 0] miss_mm_data,
  input      [ADDRESS_WIDTH - 1 : 0]   index_offset,
  
  output reg [DATA_WIDTH - 1 : 0]      rdata
); 
  integer i;

  reg [DATA_WIDTH - 1 : 0] cache [0 : CACHE_DEPTH - 1];
  
  always @ (*) begin
    rdata = cache [index_offset];
  end
  
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      for (i = 0; i < CACHE_DEPTH; i = i + 1) begin
        cache [i]          <= 32'd0;
      end
    end else if (update) begin
      cache [index_offset] <= wdata;
    end else if (refill) begin
      cache[{index_offset [ADDRESS_WIDTH - 1 : 2], 2'b00}] <= miss_mm_data [31 :0];
	  cache[{index_offset [ADDRESS_WIDTH - 1 : 2], 2'b01}] <= miss_mm_data [63 :32];
	  cache[{index_offset [ADDRESS_WIDTH - 1 : 2], 2'b10}] <= miss_mm_data [95 :64];
	  cache[{index_offset [ADDRESS_WIDTH - 1 : 2], 2'b11}] <= miss_mm_data [127 :96];
    end
  end

endmodule
