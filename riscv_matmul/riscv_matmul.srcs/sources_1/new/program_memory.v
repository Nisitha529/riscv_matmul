`timescale 1ns / 1ps

module program_memory(
  input  [31:0] read_address,  
  
  output [31:0] instruction_out
);

  reg  [31 : 0] mem_array [0 : 1023];
  wire [9 : 0]  word_index;
  
  assign word_index      = read_address [11 : 2];
  assign instruction_out = mem_array [word_index];
  
  initial begin
    $display  ("Loading program.hex...");
    $readmemh ("program.hex", mem_array);
    $display  ("Program loaded successfully");
    // Display first few instructions for testing
    $display  ("Program Memory: index[0] = 0x%08h", mem_array[0]);
    $display  ("Program Memory: index[1] = 0x%08h", mem_array[1]);
    $display  ("Program Memory: index[2] = 0x%08h", mem_array[2]);
    $display  ("Program Memory: index[3] = 0x%08h", mem_array[3]);
  end

endmodule
