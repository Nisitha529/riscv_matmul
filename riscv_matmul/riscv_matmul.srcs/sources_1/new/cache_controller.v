`timescale 1ns / 1ps

module cache_controller(
  input              clk,
  input              rst,
  
  input              memread,
  input              memwrite,
  input              ready,
  
  input      [2 : 0] tag,
  input      [4 : 0] index,
  
  output reg         refill,
  output reg         update,
  
  output reg         write,
  output reg         read,
  
  output reg         stall,
  output reg         cache_read
);

  reg     hit;
  integer i;
  
  localparam IDLE    = 2'b00;
  localparam READING = 2'b01;
  localparam WRITING = 2'b11;
  
  reg [1 : 0] current_state;
  reg [1 : 0] next_state;
  
  reg [2 : 0] cache_tag [0 : 31];
  reg         valid_bit [0 : 31];
  
  always @ (negedge clk or posedge rst) begin
    if (rst) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end
  
  always @ (*) begin
    case (current_state) 
      IDLE : begin
        if (memread && !hit) begin
          next_state = READING;
        end else if (memwrite) begin
          next_state = WRITING;
        end else begin
          next_state = IDLE;
        end
      end
      
      READING : begin
        if (ready) begin
          next_state = IDLE;
        end else  begin
          next_state = READING;
        end
      end
      
      WRITING : begin
        if (ready) begin
          next_state = IDLE;
        end else begin
          next_state = WRITING;
        end
      end
      
      default : begin
        next_state   = IDLE;
      end
      
    endcase
  end
  
  always @ (*) begin
    case (current_state) 
      IDLE :  begin
        stall        = 1'b0;
        write        = 1'b0;
        read         = 1'b0;
        update       = 1'b0;
        refill       = 1'b0;
        
        if (hit && memread) begin
          cache_read = 1'b1;
        end else begin
          cache_read = 1'b0;
        end
      end
      
      READING : begin
        stall        = 1'b1;
        write        = 1'b0;
        read         = 1'b1;
        update       = 1'b0;
        refill       = 1'b1;
        cache_read   = 1'b0;
      end
      
      WRITING : begin
        cache_read   = 1'b0;
        if (hit) begin
          stall      = 1'b1;
          write      = 1'b1;
          read       = 1'b0;
          update     = 1'b1;
          refill     = 1'b0;
        end else begin
          stall      = 1'b1;
          write      = 1'b1;
          read       = 1'b0;
          update     = 1'b0;
          refill     = 1'b0;
        end
      end
      
      default : begin
        stall        = 1'b0;
        write        = 1'b0;
        read         = 1'b0;
        update       = 1'b0;
        refill       = 1'b0;
        cache_read   = 1'b0;
      end      
      
    endcase
  end
  
  always @ (*) begin
    if (valid_bit [index] && cache_tag [index] == tag) begin
      hit               <= 1'b1;
    end else begin
      hit               <= 1'b0;
    end
  end
  
  always @ (negedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        valid_bit [i]   <= 1'b0;
        cache_tag [i]   <= 3'b0;
      end
    end else if (!hit && ready && memread) begin
      valid_bit [index] <= 1'b1;
      cache_tag [index] <= tag;
    end
  end

endmodule
