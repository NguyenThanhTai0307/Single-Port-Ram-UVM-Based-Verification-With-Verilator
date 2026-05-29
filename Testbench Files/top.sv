`ifndef TOP_SV
`define TOP_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import ram_pkg::*;

module top (input clk);
  design_if top_if(clk);
  DUT_Wrapper dut_wrapper (._if (top_if));
  //single_port_sync_ram DUT (top_if);

  bind simple_ram Assertion #(
    .ADDR_WIDTH(4), .DATA_WIDTH(4), .DEPTH(16)
  ) des_asst_bind (
    .clk (clk),
    .cs (cs),
    .we (we),
    .addr (addr),
    .din (din), 
    .dout (dout)
  );

  initial begin
    uvm_config_db#(virtual design_if)::set(uvm_root::get(), "*", "top_vif", top_if);
  end
  
  initial begin
    run_test("Base_test");
  end
  
endmodule
`endif // TOP_SV