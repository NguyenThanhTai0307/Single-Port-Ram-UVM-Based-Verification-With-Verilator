`ifndef DUT_WRAPPER_SV
`define DUT_WRAPPER_SV
module DUT_Wrapper (design_if _if);
    simple_ram DUT (
        .clk (_if.clk),
        .cs (_if.cs),
        .we (_if.we),
        .addr (_if.addr),
        .din (_if.din),
        .dout (_if.dout)
        );
endmodule
`endif // DUT_WRAPPER_SV