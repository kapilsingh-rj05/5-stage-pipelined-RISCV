module control(
    input logic[6:0] opcode,
    input logic[6:0] func7,
    input logic[2:0] func3,
    output logic mdu_enable,
    output logic ALUSrc,
    output logic MemToReg,
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic Branch,
    output logic ALUOp1,
    output logic ALUOp0,
    output logic jump,
    output logic mac_en,
    output logic mvacc_en,
    output logic clracc_en
);

    always_comb begin : control
        {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000000000000;
        case(opcode)
        //R-type
        7'b0110011: begin
            if(func7==7'b0000001) begin
                {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000100100010;
            end
            else begin
                {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000000100010;
            end
        end
        //ld
        7'b0000011: begin
            {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000011110000;
        end
        //store
        7'b0100011: begin
            {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000010001000;
        end
        //branch
        7'b1100011: begin
            {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000000000101;
        end
        //i-type
        7'b0010011: begin
            {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000010100011;
        end
        //J-type
        7'b1101111: begin
            {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0001000100000;
        end
        //custom-0(MAC)
        7'b0001011: begin
            case(func3)
                3'b000: begin
                    {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b1000100000010;
                end
                3'b001: begin
                    {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0100000100000;
                end
                3'b010: begin
                    {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0010000000000;
                end
                default: begin
                    {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000000000000;
                end
            endcase
        end
        default: {mac_en,mvacc_en,clracc_en,jump,mdu_enable, ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} = 13'b0000000000000;
        endcase
    end
endmodule