module forwarding_unit(
    input logic[4:0] id_ex_rs1,
    input logic[4:0] id_ex_rs2,
    input logic[4:0] ex_mem_rd,
    input logic ex_mem_RegWrite,
    input logic[4:0] mem_wb_rd,
    input logic mem_wb_RegWrite,
    output logic[1:0] forwardA,
    output logic[1:0] forwardB
);

    always_comb begin : forwarding_unit
        forwardA=2'b00;
        forwardB=2'b00;

        if(ex_mem_RegWrite && (ex_mem_rd!=5'd0) && ex_mem_rd==id_ex_rs1) begin
            forwardA=2'b10;
        end
        else if(mem_wb_RegWrite && (mem_wb_rd!=5'd0) && mem_wb_rd==id_ex_rs1) begin
            forwardA=2'b01;
        end

        if(ex_mem_RegWrite && (ex_mem_rd!=5'd0) && ex_mem_rd==id_ex_rs2) begin
            forwardB=2'b10;
        end
        else if(mem_wb_RegWrite && (mem_wb_rd!=5'd0) && mem_wb_rd==id_ex_rs2) begin
            forwardB=2'b01;
        end
    end

endmodule