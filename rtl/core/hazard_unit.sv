module hazard_unit(
    input logic id_ex_MemRead,
    input logic[4:0] id_ex_rd,
    input logic[4:0] if_id_rs1,
    input logic[4:0] if_id_rs2,
    input logic is_branch_id,
    input logic id_ex_RegWrite,
    input logic[4:0] ex_mem_rd,
    input logic ex_mem_RegWrite,
    input logic[4:0] mem_wb_rd,
    input logic mem_wb_RegWrite,
    input logic id_ex_mdu_enable,
    input logic mdu_done,
    output logic PCWrite,
    output logic if_id_write,
    output logic control_mux_sel,
    output logic stall_out,
    output logic id_ex_write,
    output logic ex_mem_flush
);

    logic load_use_hazard;
    logic branch_hazard;
    logic mdu_hazard;

    always_comb begin
        load_use_hazard = id_ex_MemRead && (id_ex_rd!=5'd0) && ((id_ex_rd==if_id_rs1)||(id_ex_rd==if_id_rs2));

        branch_hazard = 1'b0;
        if(is_branch_id) begin
            if(id_ex_RegWrite && (id_ex_rd!=5'd0) && ((id_ex_rd==if_id_rs1) || (id_ex_rd==if_id_rs2))) 
                branch_hazard = 1'b1;
            else if(ex_mem_RegWrite && (ex_mem_rd!=5'd0) && ((ex_mem_rd==if_id_rs1) || (ex_mem_rd==if_id_rs2))) 
                branch_hazard = 1'b1;
            else if(mem_wb_RegWrite && (mem_wb_rd!=5'd0) && ((mem_wb_rd==if_id_rs1) || (mem_wb_rd==if_id_rs2))) 
                branch_hazard = 1'b1;
        end

        mdu_hazard = id_ex_mdu_enable && !mdu_done;
    end

    always_comb begin
        PCWrite = 1'b1;
        if_id_write = 1'b1;
        control_mux_sel = 1'b1;
        stall_out = 1'b0;
        id_ex_write = 1'b1;
        ex_mem_flush = 1'b0;

        if(mdu_hazard) begin
            PCWrite = 1'b0;
            if_id_write = 1'b0;
            id_ex_write = 1'b0;
            ex_mem_flush = 1'b1;
            stall_out = 1'b1;
        end
        else if(load_use_hazard || branch_hazard) begin
            PCWrite = 1'b0;
            if_id_write = 1'b0;
            id_ex_write = 1'b1;
            ex_mem_flush = 1'b0;
            control_mux_sel = 1'b0;
            stall_out = 1'b1;
        end
    end

endmodule