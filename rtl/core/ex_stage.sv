import pipeline_pkg::*;
import riscv_pkg::*;

module ex_stage(
    input id_ex_t id_ex_in,
    input ex_mem_t ex_mem_reg,
    input mem_wb_t mem_wb_reg,
    input logic[31:0] wb_writeData,
    output ex_mem_t ex_mem_out
);

    logic[3:0] aluControl;
    logic[31:0] alu_val1, alu_val2_raw;
    logic[31:0] alu_val2, aluR, ex_pc;
    logic aluZero;
    logic[1:0] forwardA, forwardB;

    forwarding_unit fwd(.id_ex_rs1(id_ex_in.rs1), .id_ex_rs2(id_ex_in.rs2), .ex_mem_rd(ex_mem_reg.rd), .ex_mem_RegWrite(ex_mem_reg.control[3]), .mem_wb_rd(mem_wb_reg.rd), .mem_wb_RegWrite(mem_wb_reg.control[0]), .forwardA(forwardA), .forwardB(forwardB));

    ALU alu(.aluControl(aluControl), .val1(alu_val1), .val2(alu_val2), .zero(aluZero), .aluResult(aluR));
    alu_control alu_control(.func3(id_ex_in.func3[2:0]), .bit30(id_ex_in.func3[3]), .ALUOp({id_ex_in.control[1], id_ex_in.control[0]}), .aluControl(aluControl));

    assign alu_val1 = (forwardA==2'b10) ? ex_mem_reg.aluR : (forwardA==2'b01) ? wb_writeData : id_ex_in.rv1;

    assign alu_val2_raw = (forwardB==2'b10) ? ex_mem_reg.aluR : (forwardB==2'b01) ? wb_writeData : id_ex_in.rv2;
    
    assign alu_val2 = id_ex_in.control[7] ? id_ex_in.imm : alu_val2_raw;

    assign ex_pc = id_ex_in.pc + id_ex_in.imm;
    assign ex_mem_out.aluR = aluR;
    assign ex_mem_out.rv2 = id_ex_in.rv2;
    assign ex_mem_out.rd = id_ex_in.rd;
    assign ex_mem_out.zero = aluZero;
    assign ex_mem_out.control = id_ex_in.control[6:2];

    always_comb begin
        if (id_ex_in.rd == 5'd4 || id_ex_in.rd == 5'd5) begin
            $display("FWD DEBUG (rd=%d):", id_ex_in.rd);
            $display("  EX/MEM: rd=%d, RegWrite=%b, aluR=%d", ex_mem_reg.rd, ex_mem_reg.control[3], ex_mem_reg.aluR);
            $display("  MEM/WB: rd=%d, RegWrite=%b, wb_writeData=%d", mem_wb_reg.rd, mem_wb_reg.control[0], wb_writeData);
            $display("  FWD: forwardA=%b, forwardB=%b", forwardA, forwardB);
            $display("  ALU IN: val1=%d, val2_raw=%d, imm=%d, alu_val2=%d", alu_val1, alu_val2_raw, id_ex_in.imm, alu_val2);
        end
    end

endmodule