`ifndef INPUT_MONITOR_SV
`define INPUT_MONITOR_SV
class Input_monitor extends uvm_monitor;
  `uvm_component_utils(Input_monitor)

  uvm_analysis_port#(Input_item) analysis_port;
  Input_item m_item;
  virtual design_if m_vif; 

  bit sample_enable = 0;
  int trans_count = 0;

  function new(string name = "Input_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual design_if)::get(this, "", "top_vif", m_vif))
      `uvm_fatal(get_type_name(), "m_vif not set at top level");

  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      m_item = Input_item::type_id::create("m_item");
      @(m_vif.cb);

      if(sample_enable) begin
        trans_count += 1;

      m_item.cs = m_vif.cs;
      m_item.we = m_vif.we;
      m_item.din = m_vif.din;
      m_item.addr = m_vif.addr;
      
      if(m_vif.cs) begin
        `uvm_info(get_type_name(), $sformatf("cs = %0b || we = %0b || addr  = 0x%0h || din = 0x%0h", 
        m_item.cs, m_item.we, m_item.addr, m_item.din), UVM_LOW)
        if (m_vif.we)
          m_item.print();
      end
      analysis_port.write(m_item);
    end
    end
  endtask
endclass
`endif // INPUT_MONITOR_SV