`timescale 1ns / 1ps

module data_mem_sys(
  input           clk,
  input           rst,
  
  input           memread,
  input           memwrite,
  input  [9 : 0]  wordaddress,
  input  [31 : 0] datain,
  
  output          stall,
  output [31 : 0] dataout
);

  wire           ready_c;
  wire           refill_c;
  wire           update_c;
  wire           write_c;
  wire           read_c;
  wire           stall_c;
  wire           hit_c;
  
  wire [127 : 0] miss_mm_data_c;
  
  cache_controller cache_controller_01 (
    .clk          (clk),
    .rst          (rst),
    
    .memread      (memread),
    .memwrite     (memwrite),
    .ready        (ready_c),
    
    .tag          (wordaddress [9 : 7]),
    .index        (wordaddress [6 : 2]),
    
    .refill       (refill_c),
    .update       (update_c),
    
    .write        (write_c),
    .read         (read_c),
    
    .stall        (stall_c),
    .cache_read   (hit_c)
  );
  
  data_mem data_mem_01 (
    .clk          (clk),
    .reset        (rst),
    
    .write        (write_c),
    .read         (read_c),
    .wdata        (datain),
    .addr         (wordaddress),
    
    .miss_mm_data (miss_mm_data_c),
    .ready        (ready_c)
  );
  
  cache_mem cache_mem_01 (
    .clk          (clk),
    .reset        (rst),
    
    .refill       (refill_c),
    .update       (update_c),
    
    .read         (hit_c),
    .wdata        (datain),
    
    .miss_mm_data (miss_mm_data_c),
    .index_offset (wordaddress [6 : 0]),
    
    .rdata        (dataout)
  );
  
  assign stall = stall_c;

endmodule
