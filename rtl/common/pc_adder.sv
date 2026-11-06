module pc_adder(
    input logic[31:0] pc_prev,
    output logic[31:0] pc_next
);

    assign pc_next = pc_prev + 32'd4;

endmodule