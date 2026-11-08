module regfile(
    input logic[4:0] rs1,
    input logic[4:0] rs2,
    input logic clk,
    input logic RegWrite,
    input logic[4:0] rd,
    input logic[31:0] writeData,
    output logic[31:0] rv1,
    output logic[31:0] rv2 
);

    logic[31:0] registers[0:31];

    always_ff@(posedge clk) begin : register
        if(RegWrite && (rd!=5'd0)) begin
            registers[rd] <= writeData;
        end
    end

    assign rv1 = (rs1==5'd0) ? 32'd0 : ((RegWrite && rs1==rd) ? writeData : registers[rs1]);
    assign rv2 = (rs2==5'd0) ? 32'd0 : ((RegWrite && rs2==rd) ? writeData : registers[rs2]);

endmodule