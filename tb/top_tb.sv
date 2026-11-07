`timescale 1ns / 1ps

module top_tb();

    logic clock;
    logic reset;

    top dut (
        .clk(clock),
        .reset(reset)
    );

    // Clock Generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // Waveform Dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
    end

    // Stimulus & Verification
    initial begin
        reset = 0;
        #20;
        reset = 1; 
        
        // Wait 500ns (50 cycles) to let the pipeline run
        #500; 

        $display("--------------------------------------------------");
        $display("ISOLATED TEST: FORWARDING (ADD, SUB, AND, OR)");
        $display("--------------------------------------------------");
        
        // Check Basic Data
        if (dut.id_stg.regfile.registers[1] == 32'd5)  $display("PASS: x1 = %0d", dut.id_stg.regfile.registers[1]); else $display("FAIL: x1 = %0d (Expected 5)", dut.id_stg.regfile.registers[1]);
        if (dut.id_stg.regfile.registers[2] == 32'd10) $display("PASS: x2 = %0d", dut.id_stg.regfile.registers[2]); else $display("FAIL: x2 = %0d (Expected 10)", dut.id_stg.regfile.registers[2]);
        
        // Check Forwarding Paths
        if (dut.id_stg.regfile.registers[3] == 32'd15) $display("PASS: x3 = 15 (ADD)"); else $display("FAIL: x3 = %0d (Expected 15)", dut.id_stg.regfile.registers[3]);
        if (dut.id_stg.regfile.registers[4] == 32'd10) $display("PASS: x4 = 10 (SUB)"); else $display("FAIL: x4 = %0d (Expected 10)", dut.id_stg.regfile.registers[4]);
        if (dut.id_stg.regfile.registers[5] == 32'd10) $display("PASS: x5 = 10 (AND)"); else $display("FAIL: x5 = %0d (Expected 10)", dut.id_stg.regfile.registers[5]);
        if (dut.id_stg.regfile.registers[6] == 32'd15) $display("PASS: x6 = 15 (OR)");  else $display("FAIL: x6 = %0d (Expected 15)", dut.id_stg.regfile.registers[6]);

        $display("--------------------------------------------------");
        $finish;
    end

endmodule