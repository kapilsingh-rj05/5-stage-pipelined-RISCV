module data_mem(
    input logic clk,
    input logic memRead,
    input logic memWrite,
    input logic[31:0] addr,
    input logic[31:0] wr_data,
    output logic[31:0] rd_data
);

    logic[31:0] data_mem[0:31];

    initial begin
        for (int i = 0; i < 32; i++) begin
            data_mem[i] = 32'd0;
        end
    end

    always_ff@(posedge clk) begin
        if(memWrite) begin
            data_mem[addr[6:2]] <= wr_data;
        end
    end

    assign rd_data = memRead ? data_mem[addr[6:2]] : 32'd0;

endmodule