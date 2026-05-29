`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV
`uvm_analysis_imp_decl(_exp)
`uvm_analysis_imp_decl(_act)

class Scoreboard extends uvm_scoreboard;
  `uvm_component_utils(Scoreboard)

  parameter DATA_WIDTH = 4;
  parameter ADDR_WIDTH = 4;

  uvm_analysis_imp_exp#(Output_item, Scoreboard) exp_analysis_export;
  uvm_analysis_imp_act#(Output_item, Scoreboard) act_analysis_export;

  Output_item exp_array[logic [ADDR_WIDTH - 1 : 0]];

  function new(string name = "Scoreboard", uvm_component parent = null);
    super.new(name, parent);
    exp_analysis_export = new("exp_analysis_export", this);
    act_analysis_export = new("act_analysis_export", this);
  endfunction

  function void write_exp(Output_item item);
    Output_item exp_item;
    if(item.cs && item.we) begin
      assert($cast(exp_item, item.clone()));
      exp_array[item.addr] = exp_item;
    end
  endfunction

  function void write_act(Output_item item);
    begin
      if(!item.we && item.cs) begin
        if(exp_array.exists(item.addr)) begin
          if(exp_array[item.addr].dout == item.dout) begin
            `uvm_info(get_type_name, $sformatf("OUTPUT MATCHED!: ADDR = 0x%0h || EXP = 0x%0h || ACT = 0x%0h", 
            item.addr, exp_array[item.addr].dout, item.dout),UVM_LOW);
          end 
          else begin
            `uvm_info(get_type_name, $sformatf("OUTPUT MISMATCHED!: ADDR = 0x%0h || EXP = 0x%0h || ACT = 0x%0h", 
            item.addr, exp_array[item.addr].dout, item.dout),UVM_LOW);
          end
          exp_array.delete(item.addr);
        end
        else
          `uvm_warning(get_type_name(), $sformatf("ADDR 0x%0h NOT EXISTS!", item.addr))
      end
    end
  endfunction

endclass
`endif // SCOREBOARD_SV