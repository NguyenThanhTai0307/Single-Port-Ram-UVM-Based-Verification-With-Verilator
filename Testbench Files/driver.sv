`ifndef DRIVER_SV
`define DRIVER_SV
class Driver extends uvm_driver #(Input_item);
  `uvm_component_utils(Driver)
  virtual design_if d_vif;
  Input_item d_item;

  function new(string name = "Driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual design_if)::get(this, "", "top_vif", d_vif))
    	`uvm_fatal(get_type_name(), "d_vif not get at top level");
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(d_vif.cb);
      seq_item_port.get_next_item(d_item);
      d_vif.cb.cs <= d_item.cs;
      d_vif.cb.we <= d_item.we;
      d_vif.cb.addr <= d_item.addr;
      d_vif.cb.din <= d_item.din;

      @(d_vif.cb);
      d_vif.cb.cs <= 0;
      seq_item_port.item_done();
    end
  endtask
endclass
`endif // DRIVER_SV