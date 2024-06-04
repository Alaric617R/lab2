
module ISR (
    input               reset,
    input        [63:0] value,
    input               clock,
    output logic [31:0] result,         
    output logic        done
);

    typedef enum logic [2:0]  { START, STORE, COMPUTE_START, COMPUTE_IN, FIN } STATE;
    logic [4:0]  loop_counter_reg;          
    logic [4:0]  loop_counter;              
    logic [63:0] stored_value;              
    logic [31:0] intermidiate_result;       
    logic [63:0] multiplier_input;          
    logic [63:0] squared_data;              
    logic [2:0]  cur_state;                 
    logic [2:0]  next_state;                
    logic        mult_start;                
    logic        mult_start_reg;            
    logic        mult_done;                 


    always_ff @( posedge clock ) begin
        if (reset == 1) begin
            cur_state <= #1 STORE;
            stored_value <= #1 value;
            loop_counter_reg <= #1 5'b11111;
            result <= #1 32'h0000_0000;
            mult_start_reg <= #0 1'b0;
        end
        else begin
            cur_state <= #1 next_state;
            result <= #1 intermidiate_result;
            loop_counter_reg <= #1 loop_counter;
            mult_start_reg <= #1 mult_start;
        end
    end

    assign multiplier_input = {32'h0000_0000, intermidiate_result};
    // assign squared result
    mult squarer(
        .clock(clock),
        .reset(reset),
        .mcand(multiplier_input),
        .mplier(multiplier_input),
        .start(mult_start_reg),
        .product(squared_data),
        .done(mult_done)
    );

    always_comb begin
        intermidiate_result = result;
        loop_counter = loop_counter_reg;
        mult_start = mult_start_reg;
        casez(cur_state)
            START: begin
                next_state = START;
                mult_start = 1'b0;
            end
            STORE: begin
                next_state = COMPUTE_START;
                mult_start = 1'b0;
            end
            COMPUTE_START: begin
                intermidiate_result[loop_counter] = 1'b1;
                mult_start = 1'b1;
                next_state = COMPUTE_IN;
            end
            COMPUTE_IN: begin
                mult_start = 1'b0;
                if (mult_done == 1) begin
                    intermidiate_result[loop_counter_reg] = (squared_data > stored_value) ? 1'b0 : 1'b1;
                    next_state = (loop_counter_reg == 0) ? FIN : COMPUTE_START;
                    loop_counter = loop_counter_reg - 1;  
                end else begin
                    next_state = COMPUTE_IN;
                end
            end
            FIN: begin
                done = 1;
                mult_start = 1'b0;
                next_state = START;
            end
            default: begin
                next_state = START;
            end
        endcase
        done = (cur_state == FIN ) ? 1 : 0;
    end
endmodule

