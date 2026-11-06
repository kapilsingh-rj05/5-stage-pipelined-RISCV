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
        
        // Wait 1500ns (150 cycles) to process all instructions
        #1500; 

        $display("----------------------------------------");
        $display("TEST: ADDI x5 REGISTERS (WITH NOPs)");
        $display("----------------------------------------");
        
        if (dut.id_stg.regfile.registers[1] == 32'd10) $display("PASS: x1 = %0d", dut.id_stg.regfile.registers[1]); else $display("FAIL: x1 = %0d (Expected 10)", dut.id_stg.regfile.registers[1]);
        if (dut.id_stg.regfile.registers[2] == 32'd20) $display("PASS: x2 = %0d", dut.id_stg.regfile.registers[2]); else $display("FAIL: x2 = %0d (Expected 20)", dut.id_stg.regfile.registers[2]);
        if (dut.id_stg.regfile.registers[3] == 32'd30) $display("PASS: x3 = %0d", dut.id_stg.regfile.registers[3]); else $display("FAIL: x3 = %0d (Expected 30)", dut.id_stg.regfile.registers[3]);
        if (dut.id_stg.regfile.registers[4] == 32'd40) $display("PASS: x4 = %0d", dut.id_stg.regfile.registers[4]); else $display("FAIL: x4 = %0d (Expected 40)", dut.id_stg.regfile.registers[4]);
        if (dut.id_stg.regfile.registers[5] == 32'd50) $display("PASS: x5 = %0d", dut.id_stg.regfile.registers[5]); else $display("FAIL: x5 = %0d (Expected 50)", dut.id_stg.regfile.registers[5]);
        
        // Check that x0 is hardwired to 0
        if (dut.id_stg.regfile.registers[0] == 32'd0)  $display("PASS: x0 = 0");
        else                                          $display("FAIL: x0 != 0");

        $display("----------------------------------------");
        $finish;
    end

endmodule