`timescale 1ns / 1ps

module data_memory(
  input           clk,
  input           rst,
  
  input           memread,
  input           memwrite,
  input  [31 : 0] address,
  input  [31 : 0] write_data,
  
  output [31 : 0] read_data
);

  reg [31 : 0] d_mem [63 : 0];
  
  integer k;
  
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      for (k = 0; k < 64; k = k + 1) begin
        d_mem [k]     = 32'd00;
      end
      
      d_mem [17]      = 56;
      d_mem [15]      = 65;
      
    end else if (memwrite) begin
      d_mem [address] = write_data;
    end
  end
  
  assign read_data = (memread) ? d_mem[address] : 32'd00; 

endmodule
