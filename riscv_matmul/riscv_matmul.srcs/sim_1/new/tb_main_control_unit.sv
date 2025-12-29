`timescale 1ns / 1ps

module tb_main_control_unit();
  
  // Testbench signals
  reg [6:0] opcode;
  wire regwrite;
  wire memread;
  wire memwrite;
  wire memtoreg;
  wire alusrc;
  wire branch;
  wire [1:0] aluop;
  
  // Expected outputs storage
  reg exp_regwrite;
  reg exp_memread;
  reg exp_memwrite;
  reg exp_memtoreg;
  reg exp_alusrc;
  reg exp_branch;
  reg [1:0] exp_aluop;
  
  // Test control
  integer test_count = 0;
  integer pass_count = 0;
  integer fail_count = 0;
  reg test_pass;
  
  // Instantiate the module under test
  main_control_unit dut (
    .opcode(opcode),
    .regwrite(regwrite),
    .memread(memread),
    .memwrite(memwrite),
    .memtoreg(memtoreg),
    .alusrc(alusrc),
    .branch(branch),
    .aluop(aluop)
  );
  
  // Task to check outputs against expected values
  task check_outputs;
    input [6:0] opcode_input;
    input exp_regwrite, exp_memread, exp_memwrite, exp_memtoreg, exp_alusrc, exp_branch;
    input [1:0] exp_aluop;
    input string instruction_name;
    
    begin
      test_count = test_count + 1;
      test_pass = 1;
      
      // Apply opcode
      opcode = opcode_input;
      #10; // Wait for combinational logic to settle
      
      // Check each output
      if (regwrite !== exp_regwrite) begin
        $display("FAIL: %s (opcode: %7b) - regwrite: expected %b, got %b", 
                 instruction_name, opcode_input, exp_regwrite, regwrite);
        test_pass = 0;
      end
      
      if (memread !== exp_memread) begin
        $display("FAIL: %s (opcode: %7b) - memread: expected %b, got %b", 
                 instruction_name, opcode_input, exp_memread, memread);
        test_pass = 0;
      end
      
      if (memwrite !== exp_memwrite) begin
        $display("FAIL: %s (opcode: %7b) - memwrite: expected %b, got %b", 
                 instruction_name, opcode_input, exp_memwrite, memwrite);
        test_pass = 0;
      end
      
      if (memtoreg !== exp_memtoreg) begin
        $display("FAIL: %s (opcode: %7b) - memtoreg: expected %b, got %b", 
                 instruction_name, opcode_input, exp_memtoreg, memtoreg);
        test_pass = 0;
      end
      
      if (alusrc !== exp_alusrc) begin
        $display("FAIL: %s (opcode: %7b) - alusrc: expected %b, got %b", 
                 instruction_name, opcode_input, exp_alusrc, alusrc);
        test_pass = 0;
      end
      
      if (branch !== exp_branch) begin
        $display("FAIL: %s (opcode: %7b) - branch: expected %b, got %b", 
                 instruction_name, opcode_input, exp_branch, branch);
        test_pass = 0;
      end
      
      if (aluop !== exp_aluop) begin
        $display("FAIL: %s (opcode: %7b) - aluop: expected %b, got %b", 
                 instruction_name, opcode_input, exp_aluop, aluop);
        test_pass = 0;
      end
      
      if (test_pass) begin
        $display("PASS: %s (opcode: %7b) - All outputs match expected values", 
                 instruction_name, opcode_input);
        pass_count = pass_count + 1;
      end else begin
        fail_count = fail_count + 1;
      end
    end
  endtask
  
  // Initialize test
  initial begin
    $display("=========================================");
    $display("Starting testbench for main_control_unit");
    $display("=========================================\n");
    
    // Test 1: R-type instructions (7'b0110011)
    $display("Test 1: R-type instructions");
    check_outputs(7'b0110011, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, "R-type");
    
    // Test 2: I-type immediate instructions (7'b0010011)
    $display("\nTest 2: I-type immediate instructions");
    check_outputs(7'b0010011, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b10, "I-type");
    
    // Test 3: Load instructions (7'b0000011)
    $display("\nTest 3: Load instructions");
    check_outputs(7'b0000011, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 2'b00, "Load");
    
    // Test 4: Store instructions (7'b0100011)
    $display("\nTest 4: Store instructions");
    check_outputs(7'b0100011, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 2'b00, "Store");
    
    // Test 5: Branch instructions (7'b1100011)
    $display("\nTest 5: Branch instructions");
    check_outputs(7'b1100011, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b11, "Branch");
    
    // Test 6: Jump instructions (7'b1101111)
    $display("\nTest 6: Jump instructions");
    check_outputs(7'b1101111, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, "Jump");
    
    // Test 7: LUI instructions (7'b0110111)
    $display("\nTest 7: LUI instructions");
    check_outputs(7'b0110111, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b10, "LUI");
    
    // Test 8: Default case (undefined opcodes)
    $display("\nTest 8: Default/undefined opcodes");
    
    // Test multiple undefined opcodes
    check_outputs(7'b0000000, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, "Undefined 0000000");
    check_outputs(7'b1111111, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, "Undefined 1111111");
    check_outputs(7'b1010101, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, "Undefined 1010101");
    
    // Test 9: Additional edge cases (boundary values)
    $display("\nTest 9: Additional edge cases");
    check_outputs(7'b1110111, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, "Edge case 1");
    check_outputs(7'b0101010, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, "Edge case 2");
    
    // Test 10: Rapid opcode changes (stress test)
    $display("\nTest 10: Rapid opcode changes");
    for (integer i = 0; i < 5; i = i + 1) begin
      opcode = $random;
      #5; // Quick check without verbose output
    end
    
    // Final summary
    $display("\n=========================================");
    $display("Test Summary");
    $display("=========================================");
    $display("Total tests run: %0d", test_count);
    $display("Tests passed:    %0d", pass_count);
    $display("Tests failed:    %0d", fail_count);
    
    if (fail_count == 0) begin
      $display("\n✅ ALL TESTS PASSED!");
    end else begin
      $display("\n❌ SOME TESTS FAILED!");
    end
    
    $display("=========================================\n");
    
    // End simulation
    #10;
    $finish;
  end
  
  // Optional: Monitor to track all signal changes
  initial begin
    $monitor("Time: %0t | Opcode: %7b | Signals: {alusrc=%b, memtoreg=%b, regwrite=%b, memread=%b, memwrite=%b, branch=%b, aluop=%b}", 
             $time, opcode, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop);
  end
  
  // Generate waveform dump for visualization
  initial begin
    $dumpfile("main_control_unit.vcd");
    $dumpvars(0, tb_main_control_unit);
  end
  
endmodule