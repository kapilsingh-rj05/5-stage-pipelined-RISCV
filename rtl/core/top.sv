import pipeline_pkg::*;

module top(
    input logic reset,
    input logic clk
);

    if_id_t if_id_reg, if_id_next;
    id_ex_t id_ex_reg, id_ex_next;
    ex_mem_t ex_mem_reg, ex_mem_next;
    mem_wb_t mem_wb_reg, mem_wb_next;

    logic[31:0] pc_out, instr_out, pc_branch;
    logic PCSrc;
    logic[31:0] wb_writeData;
    logic[4:0] wb_writeRegister;
    logic wb_RegWrite_data;

    logic PCWrite, if_id_write, control_mux_sel;
    
    // IF Stage
    if_stage if_stg(.clk(clk), .reset(reset), .PCSrc(PCSrc), .pc_branch(pc_branch), .pc_out(pc_out), .instr(instr_out), .PCWrite(PCWrite));
    assign if_id_next.pc = pc_out;
    assign if_id_next.instr = instr_out;

    // ID Stage
    id_stage id_stg(.clk(clk), .reset(reset), .if_id_in(if_id_reg), .writeData(wb_writeData), .writeRegister(wb_writeRegister), .RegWrite(wb_RegWrite_data), .id_ex_out(id_ex_next), .control_mux_sel(control_mux_sel));

    // EX Stage
    ex_stage ex_stg(.id_ex_in(id_ex_reg), .ex_mem_out(ex_mem_next), .ex_mem_reg(ex_mem_reg), .mem_wb_reg(mem_wb_reg), .wb_writeData(wb_writeData));

    // MEM Stage
    mem_stage mem_stg(.ex_mem_in(ex_mem_reg), .mem_wb_out(mem_wb_next), .PCSrc(PCSrc), .pc_branch(pc_branch), .clk(clk));

    // WB Stage
    wb_stage wb_stg(.mem_wb_in(mem_wb_reg), .writeData(wb_writeData), .writeRegister(wb_writeRegister), .RegWrite_data(wb_RegWrite_data));

    //hazard unit
    hazard_unit hz(.id_ex_MemRead(id_ex_reg.control[4]), .id_ex_rd(id_ex_reg.rd), .if_id_rs1(if_id_reg.instr[19:15]), .if_id_rs2(if_id_reg.instr[24:20]), .PCWrite(PCWrite), .if_id_write(if_id_write), .control_mux_sel(control_mux_sel));

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            if_id_reg <= '{pc: 32'd0, instr: 32'h00000013}; // NOP
            id_ex_reg <= '{default: 0};
            ex_mem_reg <= '{default: 0};
            mem_wb_reg <= '{default: 0};
        end else begin
            if(if_id_write) begin
                if_id_reg <= if_id_next;
            end
            id_ex_reg <= id_ex_next;
            ex_mem_reg <= ex_mem_next;
            mem_wb_reg <= mem_wb_next;
        end
    end

endmodule