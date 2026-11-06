import pipeline_pkg::*;
import riscv_pkg::*;

module ex_stage(
    input id_ex_t id_ex_in,
    output ex_mem_t ex_mem_out
);

    logic[3:0] aluControl;
    logic[31:0] alu_val2, aluR, ex_pc;
    logic aluZero;

    assign alu_val2 = id_ex_in.control[7] ? id_ex_in.imm : id_ex_in.rv2;

    ALU alu(.aluControl(aluControl), .val1(id_ex_in.rv1), .val2(alu_val2), .zero(aluZero), .aluResult(aluR));
    alu_control alu_control(.func3(id_ex_in.func3[2:0]), .bit30(id_ex_in.func3[3]), .ALUOp({id_ex_in.control[1], id_ex_in.control[0]}), .aluControl(aluControl));

    assign ex_pc = id_ex_in.pc + id_ex_in.imm;
    assign ex_mem_out.aluR = aluR;
    assign ex_mem_out.rv2 = id_ex_in.rv2;
    assign ex_mem_out.rd = id_ex_in.rd;
    assign ex_mem_out.zero = aluZero;
    assign ex_mem_out.control = id_ex_in.control[6:2];

endmodule