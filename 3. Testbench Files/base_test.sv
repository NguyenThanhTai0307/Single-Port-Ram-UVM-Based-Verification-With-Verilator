`ifndef BASE_TEST_SV
`define BASE_TEST_SV
class Base_test extends uvm_test;
  `uvm_component_utils(Base_test)
  Environment env;
  Base_sequence b_seq;

  function new(string name = "Base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = Environment::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    b_seq = Base_sequence::type_id::create("b_seq");

    env.in_agt.mon.sample_enable = 1;
    env.out_agt.mon.sample_enable = 1;

    b_seq.start(env.in_agt.seqr);

    if(env.in_agt.mon.trans_count == 2*b_seq.loop)
      env.in_agt.mon.sample_enable = 0;

    if(env.out_agt.mon.trans_count == 2*b_seq.loop) begin
      repeat(2) @(env.out_agt.mon.m_vif.cb);
      env.out_agt.mon.sample_enable = 0;
    end

    env.fcov.report_data();
    
    phase.drop_objection(this);
  endtask
endclass
`endif // BASE_TEST_SV