`timescale 1ns/100ps

parameter CLOCK_PERIOD = 100;

module CORDIC_TESTBENCH;

    //Module Wires
    logic clock;
    logic [15:0] Xout, Yout;
    logic [15:0] Xin, Yin;
    logic [31:0] angle;

    localparam An = 32000 * 0.607;

    CORDIC TEST_RUN(
        .clock(clock),
        .x_start(Xin),
        .y_start(Yin),
        .angle(angle),
        .x_out(Xout),
        .y_out(Yout)
    );

    always begin
        #(CLOCK_PERIOD/2);
        clock=~clock;
    end

    initial begin
        $display("STARTING TESTBENCH!\n");
        $monitor($time, , Xout, , Yout, , angle);

        //set initial values
        angle = 'b00000000000000000000000000000000;
        Xin = An;     // Xout should be 32000*cos(angle)
        Yin = 0;      // Yout should be 32000*sin(angle)

        //set clock
        clock = 0;

        #100

        // Test 1
        #4000                                           
        angle = 'b00100000000000000000000000000000; // example: 45 deg = 45/360 * 2^32 = 32'b00100000000000000000000000000000 = 45.000 degrees -> atan(2^0)

        // Test 2
        #4000
        angle = 'b00101010101010101010101010101010; // 60 deg

        // Test 3
        #4000
        angle = 'b01000000000000000000000000000000; // 90 deg

    #4000
    $write("ENDING TESTBENCH!\n");
    $finish;

    end
endmodule