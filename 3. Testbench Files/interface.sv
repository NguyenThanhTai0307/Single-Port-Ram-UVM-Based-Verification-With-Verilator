`ifndef INTERFACE_SV
`define INTERFACE_SV
interface design_if #(
  parameter DATA_WIDTH = 4,
  parameter ADDR_WIDTH = 4,
  parameter DEPTH = 14  
) (input clk);
  logic [DATA_WIDTH - 1 : 0] din;
  logic [DATA_WIDTH - 1 : 0] dout;
  logic [ADDR_WIDTH - 1 : 0] addr;
  logic cs, we;

  clocking cb @(posedge clk);
      default input #1step output #0;
      input dout;
      output cs, we, din, addr;
  endclocking 
endinterface
`endif // INTERFACE_SV