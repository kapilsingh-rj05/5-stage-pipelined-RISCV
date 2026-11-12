module instruction_mem(
    input logic[31:0] addr,
    output logic[31:0] instr
);

    logic[31:0] instr_mem[0:1023];

    initial begin
        $readmemh("../tb/instructions.hex", instr_mem);
    end

    assign instr = instr_mem[addr[11:2]];

endmodule