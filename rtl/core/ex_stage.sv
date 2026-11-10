import pipeline_pkg::*;
import riscv_pkg::*;

module ex_stage(
    input logic clk,
    input logic reset,
    input id_ex_t id_ex_in,
    input ex_mem_t ex_mem_reg,
    input mem_wb_t mem_wb_reg,
    input logic[31:0] wb_writeData,
    output ex_mem_t ex_mem_out,
    output logic mdu_done
);

    logic[3:0] aluControl;
    logic[31:0] alu_val1, alu_val2_raw;
    logic[31:0] alu_val2, aluR, ex_pc;
    logic aluZero;
    logic[1:0] forwardA, forwardB;
    logic mdu_start;
    logic[31:0] mdu_result;

    forwarding_unit fwd(.id_ex_rs1(id_ex_in.rs1), .id_ex_rs2(id_ex_in.rs2), .ex_mem_rd(ex_mem_reg.rd), .ex_mem_RegWrite(ex_mem_reg.control[3]), .mem_wb_rd(mem_wb_reg.rd), .mem_wb_RegWrite(mem_wb_reg.control[0]), .forwardA(forwardA), .forwardB(forwardB));

    ALU alu(.aluControl(aluControl), .val1(alu_val1), .val2(alu_val2), .zero(aluZero), .aluResult(aluR));
    alu_control alu_control(.func3(id_ex_in.func3[2:0]), .bit30(id_ex_in.func3[3]), .ALUOp({id_ex_in.control[1], id_ex_in.control[0]}), .aluControl(aluControl));
    mulDivUnit mdu(.clk(clk), .reset(reset), .start(mdu_start), .done(mdu_done), .func3(id_ex_in.func3[2:0]), .a(alu_val1), .b(alu_val2_raw), .result(mdu_result));

    assign alu_val1 = (forwardA==2'b10) ? ex_mem_reg.aluR : (forwardA==2'b01) ? wb_writeData : id_ex_in.rv1;

    assign alu_val2_raw = (forwardB==2'b10) ? ex_mem_reg.aluR : (forwardB==2'b01) ? wb_writeData : id_ex_in.rv2;
    
    assign alu_val2 = id_ex_in.control[7] ? id_ex_in.imm : alu_val2_raw;
    assign mdu_start = id_ex_in.mdu_enable && !mdu_done;

    // assign ex_pc = id_ex_in.pc + id_ex_in.imm;
    assign ex_mem_out.aluR = id_ex_in.mdu_enable ? mdu_result : aluR;
    assign ex_mem_out.rv2 = alu_val2_raw;
    assign ex_mem_out.rd = id_ex_in.rd;
    // assign ex_mem_out.zero = aluZero;
    assign ex_mem_out.control = id_ex_in.control[6:2];

endmodule