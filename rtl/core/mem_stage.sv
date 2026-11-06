import pipeline_pkg::*;

module mem_stage(
    input logic clk,
    input  ex_mem_t ex_mem_in,
    output mem_wb_t mem_wb_out,
    output logic PCSrc,
    output logic[31:0] pc_branch
);
    logic [31:0] r_data;

    data_mem dMem(.memRead(ex_mem_in.control[2]), .memWrite(ex_mem_in.control[1]), .addr(ex_mem_in.aluR), .wr_data(ex_mem_in.rv2), .rd_data(r_data), .clk(clk));

    assign PCSrc = ex_mem_in.zero & ex_mem_in.control[0];
    assign pc_branch = ex_mem_in.pc;
    assign mem_wb_out.r_data = r_data;
    assign mem_wb_out.aluR = ex_mem_in.aluR;
    assign mem_wb_out.rd = ex_mem_in.rd;
    assign mem_wb_out.control = ex_mem_in.control[4:3];
endmodule