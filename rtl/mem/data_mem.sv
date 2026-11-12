module data_mem(
    input logic clk,
    input logic memRead,
    input logic memWrite,
    input logic[31:0] addr,
    input logic[31:0] wr_data,
    output logic[31:0] rd_data
);

    logic[31:0] data_mem[0:1023];

    initial begin
        $readmemh("../tb/data.hex", data_mem);
    end

    logic[31:0] offset_addr = addr-32'h1000;

    always_ff@(posedge clk) begin
        if(memWrite) begin
            data_mem[offset_addr[11:2]] <= wr_data;
        end
    end

    assign rd_data = memRead ? data_mem[offset_addr[11:2]] : 32'd0;

endmodule