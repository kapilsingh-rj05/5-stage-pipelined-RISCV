`timescale 1ns / 1ps

module top_tb();

    logic clock;
    logic reset;

    top dut (
        .clk(clock),
        .reset(reset)
    );

    // Clock Generation (100 MHz, 10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // Waveform Dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
    end

    // Stimulus & Automated Verification
    initial begin
        int errors = 0;

        // Apply Reset
        reset = 0;
        #20;
        reset = 1; 

        // Wait 600ns (60 cycles) to let the entire pipeline and branch drains finish
        #600; 

        $display("\n==================================================");
        $display("   HAZARD UNIT VERIFICATION: FORWARDING & BRANCH   ");
        $display("==================================================");

        // --- 1. Base Setup Checks ---
        if (dut.id_stg.regfile.registers[1] == 32'd10)
            $display("[PASS] x1 = 10 (Setup Base)");
        else begin
            $display("[FAIL] x1 = %0d (Expected 10)", dut.id_stg.regfile.registers[1]);
            errors++;
        end

        if (dut.id_stg.regfile.registers[2] == 32'd20)
            $display("[PASS] x2 = 20 (Setup Base)");
        else begin
            $display("[FAIL] x2 = %0d (Expected 20)", dut.id_stg.regfile.registers[2]);
            errors++;
        end

        // --- 2. RAW Forwarding Checks ---
        if (dut.id_stg.regfile.registers[3] == 32'd30)
            $display("[PASS] x3 = 30 (ADD)");
        else begin
            $display("[FAIL] x3 = %0d (Expected 30)", dut.id_stg.regfile.registers[3]);
            errors++;
        end

        if (dut.id_stg.regfile.registers[4] == 32'd20)
            $display("[PASS] x4 = 20 (SUB with EX-to-EX Forwarding)");
        else begin
            $display("[FAIL] x4 = %0d (Expected 20 from forwarded x3)", dut.id_stg.regfile.registers[4]);
            errors++;
        end

        if (dut.id_stg.regfile.registers[5] == 32'd20)
            $display("[PASS] x5 = 20 (AND with Dual Forwarding)");
        else begin
            $display("[FAIL] x5 = %0d (Expected 20)", dut.id_stg.regfile.registers[5]);
            errors++;
        end

        if (dut.id_stg.regfile.registers[6] == 32'd30)
            $display("[PASS] x6 = 30 (OR with Forwarding)");
        else begin
            $display("[FAIL] x6 = %0d (Expected 30)", dut.id_stg.regfile.registers[6]);
            errors++;
        end

        // --- 3. Branch Hazard Checks ---
        if (dut.id_stg.regfile.registers[7] == 32'd1)
            $display("[PASS] x7 = 1  (Branch Not Taken: Fallthrough Executed)");
        else begin
            $display("[FAIL] x7 = %0d (Expected 1)", dut.id_stg.regfile.registers[7]);
            errors++;
        end

        if (dut.id_stg.regfile.registers[8] == 32'd42)
            $display("[PASS] x8 = 42 (Branch Taken: Poison instruction successfully flushed)");
        else if (dut.id_stg.regfile.registers[8] == 32'd99) begin
            $display("[FAIL] x8 = 99 (CRITICAL HAZARD ERROR: Poison instruction was NOT flushed on taken branch!)");
            errors++;
        end else begin
            $display("[FAIL] x8 = %0d (Expected 42)", dut.id_stg.regfile.registers[8]);
            errors++;
        end

        $display("==================================================");
        if (errors == 0)
            $display(">>> ALL HAZARD TESTS PASSED SUCCESSFULLY! <<<");
        else
            $display(">>> TEST COMPLETED WITH %0d FAILURE(S) <<<", errors);
        $display("==================================================\n");

        $finish;
    end

endmodule