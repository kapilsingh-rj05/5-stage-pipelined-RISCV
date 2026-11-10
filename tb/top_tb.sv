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
        forever #5 clock = ~clock; // 10ns period
    end

    // Waveform Dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
    end

    // Stimulus & Verification
    initial begin
        int errors = 0;

        reset = 0;
        #20;
        reset = 1; 
        
        // Wait 3000ns to allow 6x 32-cycle MDU operations to fully complete
        #3000; 

        $display("\n========================================================");
        $display("   M-EXTENSION TEST: MULTIPLY, DIVIDE & EDGE CASES");
        $display("========================================================");
        
        // 1. Multiply Check (20 * 6 = 120)
        if (dut.id_stg.regfile.registers[4] == 32'd120) 
            $display("[PASS] x4 = 120        (MUL: 20 * 6)"); 
        else begin $display("[FAIL] x4 = %0d (Expected 120)", dut.id_stg.regfile.registers[4]); errors++; end
        
        // 2. Signed Divide Check (20 / -3 = -6)
        if (dut.id_stg.regfile.registers[5] == 32'hFFFFFFFA) 
            $display("[PASS] x5 = -6         (DIV: 20 / -3 signed)"); 
        else begin $display("[FAIL] x5 = %0h (Expected FFFFFFFA)", dut.id_stg.regfile.registers[5]); errors++; end

        // 3. Signed Remainder Check (20 % -3 = 2)
        if (dut.id_stg.regfile.registers[6] == 32'd2) 
            $display("[PASS] x6 = 2          (REM: 20 %% -3 signed)"); 
        else begin $display("[FAIL] x6 = %0d (Expected 2)", dut.id_stg.regfile.registers[6]); errors++; end

        // 4. Unsigned Divide Check (20 / 6 = 3)
        if (dut.id_stg.regfile.registers[7] == 32'd3) 
            $display("[PASS] x7 = 3          (DIVU: 20 / 6 unsigned)"); 
        else begin $display("[FAIL] x7 = %0d (Expected 3)", dut.id_stg.regfile.registers[7]); errors++; end

        // 5. Divide by Zero Check (20 / 0 = -1)
        if (dut.id_stg.regfile.registers[8] == 32'hFFFFFFFF) 
            $display("[PASS] x8 = -1         (DIV: Divide by zero yields -1)"); 
        else begin $display("[FAIL] x8 = %0h (Expected FFFFFFFF)", dut.id_stg.regfile.registers[8]); errors++; end

        // 6. Remainder by Zero Check (20 % 0 = 20)
        if (dut.id_stg.regfile.registers[9] == 32'd20) 
            $display("[PASS] x9 = 20         (REM: Remainder by zero yields dividend)"); 
        else begin $display("[FAIL] x9 = %0d (Expected 20)", dut.id_stg.regfile.registers[9]); errors++; end

        $display("========================================================");
        if (errors == 0)
            $display(">>> ALL TESTS PASSED! RV32IM MDU IS 100%% FUNCTIONAL! <<<");
        else
            $display(">>> TEST COMPLETED WITH %0d FAILURE(S) <<<", errors);
        $display("========================================================\n");

        $finish;
    end

endmodule