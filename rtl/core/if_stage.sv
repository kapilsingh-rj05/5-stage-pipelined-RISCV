import pipeline_pkg::*;

module if_stage(
    input logic clk, reset, PCSrc,
    input logic[31:0] pc_branch,
    input logic PCWrite,
    output logic[31:0] pc_out, instr
);

    logic[31:0] pcPlus4, next_pc;

    assign next_pc = PCSrc ? pc_branch : pcPlus4;

    pc_adder pc_adder(.pc_prev(pc_out), .pc_next(pcPlus4));
    program_counter pc(.reset(reset), .clk(clk), .pc_in(next_pc), .pc_out(pc_out), .enable(PCWrite));
    instruction_mem IMEM(.addr(pc_out), .instr(instr));

endmodule