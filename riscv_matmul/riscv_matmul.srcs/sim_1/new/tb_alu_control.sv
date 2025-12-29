`timescale 1ns / 1ps

module tb_alu_control();
  
  // Testbench signals
  reg [2:0] funct3;
  reg [6:0] funct7;
  reg [1:0] alu_op;
  wire [3:0] alu_control_out;
  
  // Expected output storage
  reg [3:0] exp_alu_control_out;
  
  // Test control
  integer test_count = 0;
  integer pass_count = 0;
  integer fail_count = 0;
  reg test_pass;
  
  // Instruction names for reporting
  string instruction_name;
  
  // Instantiate the module under test
  alu_control dut (
    .funct3(funct3),
    .funct7(funct7),
    .alu_op(alu_op),
    .alu_control_out(alu_control_out)
  );
  
  // Task to check outputs against expected values
  task check_outputs;
    input [1:0] alu_op_input;
    input [6:0] funct7_input;
    input [2:0] funct3_input;
    input [3:0] exp_alu_ctrl;
    input string instr_name;
    
    begin
      test_count = test_count + 1;
      test_pass = 1;
      
      // Apply inputs
      alu_op = alu_op_input;
      funct7 = funct7_input;
      funct3 = funct3_input;
      instruction_name = instr_name;
      
      #10; // Wait for combinational logic to settle
      
      // Check output
      if (alu_control_out !== exp_alu_ctrl) begin
        $display("FAIL: %s", instruction_name);
        $display("  Inputs: alu_op=%b, funct7=%b, funct3=%b", 
                 alu_op_input, funct7_input, funct3_input);
        $display("  Expected: %b (decimal %0d)", exp_alu_ctrl, exp_alu_ctrl);
        $display("  Got:      %b (decimal %0d)", alu_control_out, alu_control_out);
        test_pass = 0;
      end
      
      if (test_pass) begin
        $display("PASS: %s", instruction_name);
        pass_count = pass_count + 1;
      end else begin
        fail_count = fail_count + 1;
      end
    end
  endtask
  
  // Initialize test
  initial begin
    $display("=================================");
    $display("Starting testbench for alu_control");
    $display("=================================\n");
    
    // Group tests by ALU operation type
    $display("=== R-Type Instructions (alu_op = 2'b10) ===");
    
    // Test 1: ADD instruction
    check_outputs(2'b10, 7'b0000000, 3'b000, 4'b0000, "ADD");
    
    // Test 2: SUB instruction
    check_outputs(2'b10, 7'b0100000, 3'b000, 4'b0001, "SUB");
    
    // Test 3: AND instruction
    check_outputs(2'b10, 7'b0000000, 3'b111, 4'b0010, "AND");
    
    // Test 4: OR instruction
    check_outputs(2'b10, 7'b0000000, 3'b110, 4'b0011, "OR");
    
    // Test 5: XOR instruction
    check_outputs(2'b10, 7'b0000000, 3'b100, 4'b0100, "XOR");
    
    // Test 6: SLL (Shift Left Logical) instruction
    check_outputs(2'b10, 7'b0000000, 3'b001, 4'b0101, "SLL");
    
    // Test 7: SRL (Shift Right Logical) instruction
    check_outputs(2'b10, 7'b0000000, 3'b101, 4'b0110, "SRL");
    
    // Test 8: SRA (Shift Right Arithmetic) instruction
    check_outputs(2'b10, 7'b0100000, 3'b101, 4'b0111, "SRA");
    
    // Test 9: SLT (Set Less Than) instruction
    check_outputs(2'b10, 7'b0000000, 3'b010, 4'b1000, "SLT");
    
    // Test additional R-type variations
    $display("\n=== Additional R-Type Tests ===");
    check_outputs(2'b10, 7'b0000000, 3'b011, 4'b0000, "R-type with funct3=011 (defaults to ADD)");
    check_outputs(2'b10, 7'b1111111, 3'b000, 4'b0000, "R-type with funct7=1111111 (defaults to ADD)");
    
    $display("\n=== Load/Store Instructions (alu_op = 2'b00) ===");
    // Test load/store operations - should all be ADD for address calculation
    check_outputs(2'b00, 7'b0000000, 3'b000, 4'b0000, "Load (LB/LH/LW/LBU/LHU) - funct3=000");
    check_outputs(2'b00, 7'b0000000, 3'b001, 4'b0000, "Load (LH) - funct3=001");
    check_outputs(2'b00, 7'b0000000, 3'b010, 4'b0000, "Load (LW) - funct3=010");
    check_outputs(2'b00, 7'b0000000, 3'b011, 4'b0000, "Load (funct3=011 defaults to ADD)");
    check_outputs(2'b00, 7'b0000000, 3'b100, 4'b0000, "Load (LBU) - funct3=100");
    check_outputs(2'b00, 7'b0000000, 3'b101, 4'b0000, "Load (LHU) - funct3=101");
    check_outputs(2'b00, 7'b1111111, 3'b010, 4'b0000, "Store (SW) with funct7=1111111 (still ADD)");
    
    $display("\n=== I-Type Immediate Instructions (should use alu_op=2'b10) ===");
    // Note: I-type instructions use the same ALU control as R-type
    check_outputs(2'b10, 7'b0000000, 3'b000, 4'b0000, "ADDI");
    check_outputs(2'b10, 7'b0000000, 3'b111, 4'b0010, "ANDI");
    check_outputs(2'b10, 7'b0000000, 3'b110, 4'b0011, "ORI");
    check_outputs(2'b10, 7'b0000000, 3'b100, 4'b0100, "XORI");
    check_outputs(2'b10, 7'b0000000, 3'b001, 4'b0101, "SLLI");
    check_outputs(2'b10, 7'b0000000, 3'b101, 4'b0110, "SRLI");
    check_outputs(2'b10, 7'b0100000, 3'b101, 4'b0111, "SRAI");
    check_outputs(2'b10, 7'b0000000, 3'b010, 4'b1000, "SLTI");
    
    $display("\n=== Undefined/Default Cases ===");
    // Test undefined alu_op values
    check_outputs(2'b01, 7'b0000000, 3'b000, 4'b0000, "Undefined alu_op=01 (defaults to ADD)");
    check_outputs(2'b11, 7'b0000000, 3'b000, 4'b0000, "Undefined alu_op=11 (defaults to ADD)");
    
    // Test undefined combinations
    check_outputs(2'b10, 7'b0010000, 3'b000, 4'b0000, "Undefined funct7=0010000 (defaults to ADD)");
    check_outputs(2'b10, 7'b0000000, 3'b111, 4'b0010, "AND (re-test to ensure no interference)");
    
    $display("\n=== Edge Cases and Stress Testing ===");
    // Random testing
    for (integer i = 0; i < 10; i = i + 1) begin
      reg [1:0] rand_alu_op = $random;
      reg [6:0] rand_funct7 = $random;
      reg [2:0] rand_funct3 = $random;
      
      alu_op = rand_alu_op;
      funct7 = rand_funct7;
      funct3 = rand_funct3;
      
      #5;
      // Just observe behavior, no explicit check for random values
    end
    
    // Test all possible funct3 values for each alu_op
    $display("\n=== Exhaustive funct3 Testing ===");
    for (integer f3 = 0; f3 < 8; f3 = f3 + 1) begin
      alu_op = 2'b00;
      funct7 = 7'b0000000;
      funct3 = f3;
      #5;
      $display("alu_op=00, funct3=%3b -> alu_ctrl=%b", f3, alu_control_out);
    end
    
    // Final summary
    $display("\n=================================");
    $display("Test Summary");
    $display("=================================");
    $display("Total tests run: %0d", test_count);
    $display("Tests passed:    %0d", pass_count);
    $display("Tests failed:    %0d", fail_count);
    
    if (fail_count == 0) begin
      $display("\n✅ ALL TESTS PASSED!");
    end else begin
      $display("\n❌ SOME TESTS FAILED!");
    end
    
    $display("=================================\n");
    
    // Display ALU control code mapping
    $display("ALU Control Code Mapping:");
    $display("  0000: ADD");
    $display("  0001: SUB");
    $display("  0010: AND");
    $display("  0011: OR");
    $display("  0100: XOR");
    $display("  0101: SLL");
    $display("  0110: SRL");
    $display("  0111: SRA");
    $display("  1000: SLT");
    $display("  Default: ADD (0000)");
    
    // End simulation
    #10;
    $finish;
  end
  
  // Monitor to track signal changes
  initial begin
    // Only display changes during the main test phase
    wait(test_count > 0);
    $monitor("Time: %0t | alu_op=%b, funct7=%b, funct3=%b -> alu_ctrl=%b", 
             $time, alu_op, funct7, funct3, alu_control_out);
  end
  
  // Generate waveform dump
  initial begin
    $dumpfile("alu_control.vcd");
    $dumpvars(0, tb_alu_control);
  end
  
  // Helper function to decode ALU control signal
  function string decode_alu_ctrl(input [3:0] ctrl);
    begin
      case (ctrl)
        4'b0000: decode_alu_ctrl = "ADD";
        4'b0001: decode_alu_ctrl = "SUB";
        4'b0010: decode_alu_ctrl = "AND";
        4'b0011: decode_alu_ctrl = "OR";
        4'b0100: decode_alu_ctrl = "XOR";
        4'b0101: decode_alu_ctrl = "SLL";
        4'b0110: decode_alu_ctrl = "SRL";
        4'b0111: decode_alu_ctrl = "SRA";
        4'b1000: decode_alu_ctrl = "SLT";
        default: decode_alu_ctrl = "UNKNOWN";
      endcase
    end
  endfunction
  
endmodule