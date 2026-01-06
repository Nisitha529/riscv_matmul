`timescale 1ns / 1ps

module main_control_unit(
  input      [6 : 0] opcode,
  
  output reg         regwrite,
  output reg         memread,
  output reg         memwrite,
  output reg         memtoreg,
  output reg         alusrc,
  output reg         branch,
  output reg [1 : 0] aluop
);

  always @ (*) begin
    case (opcode) 
      7'b0110011 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}; // R-type
      7'b0010011 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}; // I-type
      7'b0000011 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00}; // Load
      7'b0100011 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00}; // Store
      7'b1100011 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01}; // Branch
      7'b1101111 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00}; // Jump
      7'b1100111 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00}; // JALR
      7'b0110111 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b11}; // LUI
      7'b0010111 : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b00}; // AUIPC
      default    : {alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00};
    endcase
  end

endmodule