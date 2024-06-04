
module ISR (
    input               reset,
    input        [63:0] value,
    input               clock,
    output logic [31:0] result,         
    output logic        done
);
    // P2 TODO: Finish answering questions for the mult module,
    //          then implement the Integer Square Root algorithm as specified
    // P2 NOTE: reset mult_defs.svh to 8 stages when using this module.

    parameter S0 = 32;                  // entering state of FSM
    parameter S1 = 33;                  // state where value will be stored and computation just starts
    parameter FIN = 34;                 // state of finish, done up for one cycle
    logic [4:0] calc_state_counter;     // state of calculation, starting from 31, ends at 0
    logic [63:0] cur_stored_value;       // stored value
    logic [31:0] intermidiate_result;   // intermediate result stored inside
    logic [63:0] squared_data;          // intermediate result squared
    logic [5:0] cur_state;              // FSM current state
    logic [5:0] next_state;             // FSM next state
    logic       mult_start, mult_reset; // flag for multiplier
    logic       mult_done;              // flag for multiplier finish

    always_ff @( posedge clock ) begin
        if (reset == 1) begin
            cur_state <= #1 S1;
            cur_stored_value <= #1 value;
            // intermidiate_result <= #1 0;
        end
        else begin
            cur_state <= #1 next_state;
            // intermidiate_result <= #1 result;
        end
    end

    // assign squared result
    mult squarer(
        .clock(clock),
        .reset(mult_reset),
        .mcand({32'h0000_0000, intermidiate_result}),
        .mplier({32'h0000_0000, intermidiate_result}),
        .start(mult_start),
        .product(squared_data),
        .done(mult_done)
    );

    always_comb begin 
        if (cur_state == S1) begin
            done = 0;
            next_state = 31;        // 31' set to 1
            {mult_start, mult_reset} = 2'b01;
            result = 0;
            intermidiate_result = 0;
        end
        // short circuit allowed?
        else if ( cur_state <= 31 && cur_state >= 0) begin
            intermidiate_result = result;
            intermidiate_result[cur_state] = 1;
            {mult_start, mult_reset} = 2'b10;       // set multiplier on
            // how should we wait until the correct squared results to be computed?
            if (mult_done == 0) begin
                next_state = cur_state;
            end
            else begin
                intermidiate_result[cur_state] = (squared_data > cur_stored_value) ? 0 : 1;
                {mult_start, mult_reset} = 2'b01;       // set multiplier off
                next_state = (cur_state == 0) ? FIN : cur_state - 1;
            end
            done = 0;
        end
        else if (cur_state == FIN) begin
            done = 1;
            next_state = S0;
        end
        else begin                                  // this has considered S0 case
            done = 0;
            next_state = S0;
        end
        // for all cases, store intermediate result to output stream
        result = intermidiate_result;             
    end





endmodule
