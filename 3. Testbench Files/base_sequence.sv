`ifndef BASE_SEQUENCE_SV
`define BASE_SEQUENCE_SV
class Base_sequence extends uvm_sequence #(Input_item);
  `uvm_object_utils(Base_sequence)
  
  parameter ADDR_WIDTH = 4;
  parameter DATA_WIDTH = 4;
  parameter DEPTH = 16;

  Input_item seq_item;
  logic [ADDR_WIDTH - 1 : 0] addr_pool[];
  logic [DATA_WIDTH - 1 : 0] data_pool[];

  int loop = 16;

  function new(string name = "Main_sequence");
    super.new(name);
  endfunction

  virtual task body();
    addr_pool = new[DEPTH];
    data_pool = new[DEPTH];

    foreach (addr_pool[i]) begin
      addr_pool[i] = 4'(i);
    end

    foreach (data_pool[i]) begin
      data_pool[i] = 4'(i);
    end

    addr_pool.shuffle();
    data_pool.shuffle();

    for(int i = 0; i < loop; i++) begin
      seq_item = Input_item::type_id::create("seq_item");
      wait_for_grant();
      if(seq_item.randomize() with {
        addr == addr_pool[i];
        din == data_pool[i];
      } == 0) begin
        `uvm_fatal(get_type_name(), $sformatf("Randomization Failed inside Base_Seq!"))
      end
      send_request(seq_item);
      wait_for_item_done();
    end
/*
    for(int i = 0; i < DEPTH; i++) begin
      seq_item = Input_item::type_id::create("req_item");
      wait_for_grant();
      assert(seq_item.randomize() with {
        cs == 1;
        we == 0;
        addr == addr_pool[i];
        din == data_pool[i];
      });
      send_request(seq_item);
      wait_for_item_done();
    end
*/
  endtask
endclass
`endif // BASE_SEQUENCE_SV