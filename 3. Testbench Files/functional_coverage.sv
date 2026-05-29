`ifndef FUNCTIONAL_COVERAGE_SV
`define FUNCTIONAL_COVERAGE_SV
import "DPI-C" context function void dpi_c_sample_coverage(byte cs, byte we, int addr, int din);
import "DPI-C" context function void dpi_c_report_coverage();

class Functional_coverage extends uvm_subscriber#(Input_item);
    `uvm_component_utils(Functional_coverage)

    parameter ADDR_WIDTH = 4;
    parameter DATA_WIDTH = 4;

    function new(string name = "Functional_coverage", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void sample(bit cs, bit we, logic [ADDR_WIDTH - 1 : 0] addr , logic [DATA_WIDTH - 1 : 0] din);
        dpi_c_sample_coverage(
            {7'b0, cs},
            {7'b0, we},
            int'(addr),
            int'(din)
        );
    endfunction

    function void report_data();
        dpi_c_report_coverage();
    endfunction

    function void write(Input_item t);
        this.sample(t.cs, t.we, t.addr, t.din);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    endfunction

// SystemVerilog covergroup defined for industry-standard compatibility (VCS/Questa).

// Functional coverage implemented via DPI-C for Verilator performance/compatibility.
/*
    Input_item fc_item;

    covergroup cg;
        c_addr : coverpoint fc_item.addr;
        c_data : coverpoint fc_item.din;
        c_cs : coverpoint fc_item.cs {
            bins slt = {1};
            bins no_slt = {0};
        }
        c_we : coverpoint fc_item.we {
            bins wr_en = {1};
            bins rd_en = {0};
        }

        read_write_all_address : cross c_we, c_addr {
            bins rd_we_all_addr = binsof(c_we) && binsof(c_addr);
        }

        ignore_cs_0 : cross c_cs, c_we, c_addr, c_data{
            ignore_bins we_cs_0 = binsof(c_cs.no_slt) && binsof(c_we);
            ignore_bins data_cs_0 = binsof(c_cs.no_slt) && binsof(c_data);
            ignore_bins addr_cs_0 = binsof(c_cs.no_slt) && binsof(c_addr);
        }
    endgroup

    function new(string name = "Functional_coverage", uvm_component parent = null);
        super.new(name, parent);
        cg = new();
    endfunction

    function void write(Input_item t);
        this.fc_item = t;
        this.cg.sample();
    endfunction
*/
endclass
`endif // FUNCTIONAL_COVERAGE_SV