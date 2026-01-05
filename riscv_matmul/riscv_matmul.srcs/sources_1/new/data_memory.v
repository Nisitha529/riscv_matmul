`timescale 1ns / 1ps

module data_memory(
  input               clk,
  input               rst,
  
  input               memread,
  input               memwrite,
  input      [2 : 0]  memop,
  input      [31 : 0] address,
  input      [31 : 0] write_data,
  
  output reg [31 : 0] read_data
);

  reg [7 : 0] d_mem [0 : 4095];
  
  integer k;
  
//  always @ (posedge clk or posedge rst) begin
//    if (rst) begin
//      for (k = 0; k < 64; k = k + 1) begin
//        d_mem [k]     = 32'd00;
//      end
      
//      d_mem [17]      = 56;
//      d_mem [15]      = 65;
      
//    end else if (memwrite) begin
//      d_mem [address] = write_data;
//    end
//  end
  
//  assign read_data = (memread) ? d_mem[address] : 32'd00;

  always @ (posedge clk) begin
    if (rst) begin
      for (k = 0; k < 4096; k = k + 1) begin
        d_mem [k] <= 8'd0;
      end
    end
  end 
  
  always @ (posedge clk) begin
    if (memwrite) begin 
      case (memop)
        3'b000 : begin // Store Byte
          d_mem[address]     <= write_data [7 : 0];
        end
        
        3'b001 : begin // Store Halfword - Little Endian
          d_mem[address]     <= write_data [7 : 0];
          d_mem[address + 1] <= write_data [15 : 8];
        end
          
        3'b010 : begin // Store Word
          d_mem[address]     <= write_data [7 : 0];
          d_mem[address + 1] <= write_data [15 : 8];
          d_mem[address + 2] <= write_data [23 : 16];
          d_mem[address + 3] <= write_data [31 : 24];
        end
        
      endcase
    end
  end
  
  always @ (*) begin
    if (!memread) begin
      read_data = 32'b0;
    end else begin
      case (memop)
        3'b000 : begin // LB (sign-extend byte)
          read_data = {{24{d_mem[address][7]}}, d_mem[address]};
        end
        
        3'b100 : begin // LBU (zero-extend byte)
          read_data = {24'b0, d_mem[address]};
        end
        
        3'b001 : begin // LH (sign-extend half)
          read_data = {{16{d_mem[address+1][7]}}, d_mem[address+1], d_mem[address]};
        end
        
        3'b101 : begin // LHU (zero-extend half)
          read_data = {16'b0, d_mem[address+1], d_mem[address]};
        end
        
        3'b010 : begin // LW
           read_data = {d_mem[address+3], d_mem[address+2], d_mem[address+1], d_mem[address]};
        end
        
        default: read_data = 32'b0;
            
      endcase
    end
  end

endmodule
