import pipeline_pkg::*;

module wb_stage(
    input  mem_wb_t mem_wb_in,
    output logic[31:0] writeData,
    output logic[4:0] writeRegister,
    output logic RegWrite_data
);
    assign writeData = mem_wb_in.control[1] ? mem_wb_in.r_data : mem_wb_in.aluR;
    assign RegWrite_data = mem_wb_in.control[0];
    assign writeRegister = mem_wb_in.rd;
    
endmodule