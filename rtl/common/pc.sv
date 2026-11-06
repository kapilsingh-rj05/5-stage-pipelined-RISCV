module program_counter(
    input logic reset,
    input logic clk,
    input logic[31:0] pc_in,
    output logic[31:0] pc_out
);

    always_ff@(posedge clk or negedge reset) begin : pc
        if(!reset) begin
            pc_out <= 32'd0;
        end
        else begin
            pc_out <= pc_in;
        end
    end

endmodule