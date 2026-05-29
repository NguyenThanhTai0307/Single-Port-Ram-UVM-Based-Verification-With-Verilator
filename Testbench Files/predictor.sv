`ifndef PREDICTOR_SV
`define PREDICTOR_SV
class Predictor extends uvm_subscriber #(Input_item);
  `uvm_component_utils(Predictor)
  uvm_analysis_port#(Output_item) analysis_port;
  Output_item exp_item;

  function new(string name = "Predictor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void write(Input_item t);
    exp_item = Output_item::type_id::create("exp_item");

    exp_item.cs = t.cs;
    exp_item.we = t.we;  
    exp_item.addr = t.addr;
    if(t.cs && t.we) begin
      exp_item.dout = t.din;
    end
    
    analysis_port.write(exp_item);
  endfunction
endclass
`endif // PREDICTOR_SV