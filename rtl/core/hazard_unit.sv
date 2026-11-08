module hazard_unit(
    input logic id_ex_MemRead,
    input logic[4:0] id_ex_rd,
    input logic[4:0] if_id_rs1,
    input logic[4:0] if_id_rs2,
    output logic PCWrite,
    output logic if_id_write,
    output logic control_mux_sel
);

    logic load_use_hazard;

    always_comb begin
        if(id_ex_MemRead && (id_ex_rd!=5'd0) && ((id_ex_rd==if_id_rs1) || (id_ex_rd==if_id_rs2))) begin
            load_use_hazard = 1'b1;
        end
        else begin
            load_use_hazard = 1'b0;
        end
    end

    always_comb begin
        if(load_use_hazard) begin
            PCWrite = 1'b0;
            if_id_write = 1'b0;
            control_mux_sel = 1'b0;
        end
        else begin
            PCWrite = 1'b1;
            if_id_write = 1'b1;
            control_mux_sel = 1'b1;
        end
    end

endmodule