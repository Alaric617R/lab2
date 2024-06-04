
// P2 TODO: Write a testbench which tests both specific edge cases and random values.
//          Base your testbench on mult_test.sv, specifically the wait_until_done task.

module testbench();
    logic           reset, clock, done, correct;
    logic [63:0]    value;
    logic [31:0]    result;
    integer i;
    
    ISR dut(
        .reset(reset),
        .value(value),
        .clock(clock),
        .result(result),
        .done(done)
    );


    // CLOCK_PERIOD is defined on the commandline by the makefile
    always begin
        #(`CLOCK_PERIOD/2.0);
        clock = ~clock;
    end

    always @(posedge clock) begin
        #(`CLOCK_PERIOD*0.2); // a short wait to let signals stabilize
        if (!correct) begin
            $display("@@@ Incorrect at time %4.0f", $time);
            $display("@@@ done:%b value:%d result:%d", done, value, result);
            $finish;
        end
    end

    task wait_4_cycle;
        integer i;
        for (i=0;i<4;i++) @(negedge clock);;
    endtask

    task wait_until_done;
        forever begin : wait_loop
            @(posedge done);
            @(negedge clock);
            if (done) begin
                $display("Done time: %4.0f", $time);
                $display("test value: %d\tresult: %d", value, result);
                disable wait_until_done;
            end
        end
    endtask

    always_comb begin
        if ( ((result*result <= value) & ((result+1)*(result+1) > value) & done === 1 )
            | ~done) begin
                correct = 1;
            end
        else 
            correct = 0;
    end


    initial begin
        reset = 1;
        clock = 0;
        value = 1001;
        @(negedge clock);
		reset = 0;
        $display("start time: %4.0f", $time);
		wait_until_done();

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 144;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 16;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 0;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 9;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 145;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 143;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        // discontinue in the middle
        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 64'hFFFF_FFFD_FFFF_FFFC;
        @(negedge clock);
		reset = 0;
        wait_4_cycle();
        reset = 1;
        value = 128;
        @(negedge clock);
        reset = 0;
        
		wait_until_done();

        // test finish stage

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 64'hFFFF_FFFD_FFFF_FFFA;
        @(negedge clock);
		reset = 0;
		wait_until_done();


        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 128;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 129;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        @(negedge clock);
        reset = 1;
        clock = 0;
        value = 16;
        @(negedge clock);
		reset = 0;
		wait_until_done();

        for (i = 0; i <= 15; i = i+1) begin
            reset = 1;
            value = i + 10;
            @(negedge clock);
            $display("Time:%4.0f  value:%h ",
                     $time,  value);
            reset = 0;
            wait_until_done();
            $display("Time:%4.0f done:%b value:%h result:%h correct:%h",
                     $time, done, value, result, correct);
        end
        // if incorrect
        if (correct == 0)  $display("@@@ Incorrect");
        // if correct
        else $display("@@@ Passed");

        $finish;
    end

endmodule

// module load vcs verdi synopsys-synth