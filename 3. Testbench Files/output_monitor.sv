`ifndef OUTPUT_MONITOR_SV
`define OUTPUT_MONITOR_SV
class Output_monitor extends uvm_monitor;
  `uvm_component_utils(Output_monitor)
  uvm_analysis_port#(Output_item) analysis_port;
  Output_item m_item;
  virtual design_if m_vif;

  bit sample_enable = 0;
  int trans_count = 0;

  function new(string name = "Output_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual design_if)::get(this, "", "top_vif", m_vif))
      `uvm_fatal(get_type_name(), "m_vif not set at top level");
  endfunction

  task run_phase(uvm_phase phase);
    forever begin 
      m_item = Output_item::type_id::create("m_item");
      @(m_vif.cb);
      if(sample_enable) begin
        trans_count += 1;
        
      m_item.addr = m_vif.addr;
      m_item.cs = m_vif.cs;
      m_item.we = m_vif.we;

      if(m_vif.cs && !m_vif.we) begin
        @(m_vif.cb);
        m_item.dout = m_vif.cb.dout;
        m_item.print();
      end
      analysis_port.write(m_item);
    end
    end
  endtask
endclass
`endif // OUTPUT_MONITOR_SV