`ifndef SYNTHESIS

//
// This is an automatically generated file from 
// dc_shell Version T-2022.03-SP3 -- Jul 12, 2022
//

// For simulation only. Do not modify.

module ISR_svsim (
    input               reset,
    input        [63:0] value,
    input               clock,
    output logic [31:0] result,         
    output logic        done
);
                

  ISR ISR( {>>{ reset }}, {>>{ value }}, {>>{ clock }}, {>>{ result }}, 
        {>>{ done }} );
endmodule
`endif
