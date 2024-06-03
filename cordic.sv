`timescale 1ns/100ps

module CORDIC(
    input clock,                        
    input signed [15:0] x_in, y_in,     // (x,y) of the input vector
    input signed [31:0] angle,          // desired rotation angle
    output signed [15:0] x_out, y_out   // output vector
    );

    // Generate table of atan values
    // all theta_i stored
    logic signed [31:0] atan_table [0:30];

    assign atan_table[00] = 'b00100000000000000000000000000000; // atan(2^0) -> 45.000 degrees -> 45/360*2^32 = 'b00100000000000000000000000000000
    assign atan_table[01] = 'b00010010111001000000010100011101; // atan(2^-1) -> 26.565 degrees
    assign atan_table[02] = 'b00001001111110110011100001011011; // atan(2^-2) -> 14.036 degrees
    assign atan_table[03] = 'b00000101000100010001000111010100; // atan(2^-3)
    assign atan_table[04] = 'b00000010100010110000110101000011;
    assign atan_table[05] = 'b00000001010001011101011111100001;
    assign atan_table[06] = 'b00000000101000101111011000011110;
    assign atan_table[07] = 'b00000000010100010111110001010101;
    assign atan_table[08] = 'b00000000001010001011111001010011;
    assign atan_table[09] = 'b00000000000101000101111100101110;
    assign atan_table[10] = 'b00000000000010100010111110011000;
    assign atan_table[11] = 'b00000000000001010001011111001100;
    assign atan_table[12] = 'b00000000000000101000101111100110;
    assign atan_table[13] = 'b00000000000000010100010111110011;
    assign atan_table[14] = 'b00000000000000001010001011111001;
    assign atan_table[15] = 'b00000000000000000101000101111100;
    assign atan_table[16] = 'b00000000000000000010100010111110;
    assign atan_table[17] = 'b00000000000000000001010001011111;
    assign atan_table[18] = 'b00000000000000000000101000101111;
    assign atan_table[19] = 'b00000000000000000000010100010111;
    assign atan_table[20] = 'b00000000000000000000001010001011;
    assign atan_table[21] = 'b00000000000000000000000101000101;
    assign atan_table[22] = 'b00000000000000000000000010100010;
    assign atan_table[23] = 'b00000000000000000000000001010001;
    assign atan_table[24] = 'b00000000000000000000000000101000;
    assign atan_table[25] = 'b00000000000000000000000000010100;
    assign atan_table[26] = 'b00000000000000000000000000001010;
    assign atan_table[27] = 'b00000000000000000000000000000101;
    assign atan_table[28] = 'b00000000000000000000000000000010;
    assign atan_table[29] = 'b00000000000000000000000000000001;
    assign atan_table[30] = 'b00000000000000000000000000000000;

    logic signed [16:0] x [0:15];
    logic signed [16:0] y [0:15];
    logic signed [31:0] z [0:15];

    // make sure rotation angle is in -pi/2 to pi/2 range
    // for example, if the angle is from pi/2 to pi, you can first rotate the vector by 90 degrees before processing the CORDIC algorithm
    logic [1:0] quadrant;
    assign quadrant = angle[31:30];

    always_ff @(posedge clock) begin
        case(quadrant)
        2'b00, 2'b11: begin
            // no changes needed for these quadrants                 
            x[0] <= x_in;
            y[0] <= y_in;
            z[0] <= angle;
        end
        2'b01: begin
            // TODO: subtract pi/2 for angle in this quadrant, adjust x and y values
            x[0] <= ;
            y[0] <= ;
            z[0] <= ;    
        end

        2'b10: begin
            // TODO: add pi/2 to angles in this quadrant, adjust x and y values
            x[0] <= ;
            y[0] <= ;
            z[0] <= ;    
        end
        endcase
    end

    // run through 15 iterations
    // TODO:    implement the iterations using "for" loop
    //          implement the bit shifting for x and y
    //          implement the calculation for remaining angle through the atan_table and the sign of current rotation angle
    //          each iteration should finish in one cycle, which means this is a 15 stage pipeline
    generate
        genvar i;
        




    endgenerate

    // assign output
    assign x_out = x[15];
    assign y_out = y[15];

endmodule


