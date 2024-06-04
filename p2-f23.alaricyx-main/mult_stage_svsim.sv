`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version T-2022.03-SP3 -- Jul 12, 2022
//

// For simulation only. Do not modify.

module mult_stage_svsim (
    input clock, reset, start,
    input [63:0] prev_sum, mplier, mcand,

    output logic [63:0] product_sum, next_mplier, next_mcand,
    output logic done
);

    

  mult_stage mult_stage( {>>{ clock }}, {>>{ reset }}, {>>{ start }}, 
        {>>{ prev_sum }}, {>>{ mplier }}, {>>{ mcand }}, {>>{ product_sum }}, 
        {>>{ next_mplier }}, {>>{ next_mcand }}, {>>{ done }} );
endmodule
`endif
