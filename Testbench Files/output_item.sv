`ifndef OUTPUT_ITEM_SV
`define OUTPUT_ITEM_SV
class Output_item extends uvm_sequence_item;
  `uvm_object_utils(Output_item)

  parameter DATA_WIDTH = 4;
  parameter ADDR_WIDTH = 4;

  rand bit cs, we;
  bit [DATA_WIDTH - 1 : 0] dout;
  rand bit [ADDR_WIDTH - 1 : 0] addr;

  function new(string name = "Output_item");
    super.new(name);
  endfunction

  function void print(string tag = "READ");
    `uvm_info(get_type_name(), $sformatf("[%0s] ADDR : 0x%0h || DOUT : 0x%0h",
     tag, addr, dout), UVM_LOW);
  endfunction
  
endclass
`endif // OUTPUT_ITEM_SV