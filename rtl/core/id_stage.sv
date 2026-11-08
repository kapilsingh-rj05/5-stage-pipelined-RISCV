import pipeline_pkg::*;

module id_stage(
    input logic clk, reset,
    input if_id_t if_id_in,
    input logic[31:0] writeData,
    input logic[4:0] writeRegister,
    input logic RegWrite,
    input logic control_mux_sel,
    input logic stall_out,
    output logic is_branch,
    output logic[31:0] branch_target,
    output logic if_flush,
    output logic PCSrc,
    output id_ex_t id_ex_out
);

    logic[31:0] rv1, rv2, imm_val;
    logic ALUSrc, MemToReg, RegWrite_if, MemRead, MemWrite, Branch, ALUOp1, ALUOp0;
    logic register_equal;

    regfile regfile(.rs1(if_id_in.instr[19:15]), .rs2(if_id_in.instr[24:20]), .clk(clk), .RegWrite(RegWrite), .rd(writeRegister), .writeData(writeData), .rv1(rv1), .rv2(rv2));
    imm_gen imm_gen(.instr(if_id_in.instr), .imm_val(imm_val));
    control ctrl(.opcode(if_id_in.instr[6:0]), .ALUSrc(ALUSrc), .MemToReg(MemToReg), .RegWrite(RegWrite_if), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .ALUOp1(ALUOp1), .ALUOp0(ALUOp0));

    assign branch_target = if_id_in.pc + imm_val;
    // assign id_ex_out.pc = if_id_in.pc;
    assign is_branch = Branch;
    assign if_flush = Branch && register_equal && !stall_out;
    assign PCSrc = if_flush;
    assign register_equal = (rv1==rv2);
    assign id_ex_out.rv1 = rv1;
    assign id_ex_out.rv2 = rv2;
    assign id_ex_out.imm = imm_val;
    assign id_ex_out.rs1 = if_id_in.instr[19:15];
    assign id_ex_out.rs2 = if_id_in.instr[24:20];
    assign id_ex_out.rd = if_id_in.instr[11:7];
    assign id_ex_out.func3 = {if_id_in.instr[30], if_id_in.instr[14:12]};
    assign id_ex_out.control = control_mux_sel ? {ALUSrc, MemToReg, RegWrite_if, MemRead, MemWrite, Branch, ALUOp1, ALUOp0} : 8'd0;  

endmodule