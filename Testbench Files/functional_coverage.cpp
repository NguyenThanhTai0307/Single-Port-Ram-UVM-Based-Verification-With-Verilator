#include<iostream>
#include<map>
#include<tuple>

int cp_cs_sel = 0;
int cp_cs_no_sel = 0;

int cp_we_wr = 0;
int cp_we_rd = 0;

std::map<int, int> cp_addr_bin;
std::map<int, int> cp_data_bin;

std::map<std::tuple<int, int, int>, int> cross_cs1_bin;

extern "C" void dpi_c_sample_coverage(unsigned char cs, unsigned char we, int addr, int din) {

    if(cs == 1){
        // Sample cs
        cp_cs_sel += 1;
        
        // Sample we
        if(we == 1)
            cp_we_wr += 1;
        else
            cp_we_rd += 1;

        // Sample addr and din
        cp_addr_bin[addr] += 1;
        cp_data_bin[din] += 1;

        //Sample the cross
        auto key = std::make_tuple(we, addr, din);
        cross_cs1_bin[key] += 1;
    }
    else {
        cp_cs_no_sel += 1;
    }

}

extern "C" void dpi_c_report_coverage() {
    std::cout << "\n===================================================\n";
    std::cout << "               DPI-C COVERAGE REPORT               \n";
    std::cout << "===================================================\n";
    
    std::cout << "[cp_cs]   CS=1 Hits: " << cp_cs_sel << " | CS=0 Hits: " << cp_cs_no_sel << "\n";
    std::cout << "[cp_we]   Write Hits: " << cp_we_wr << " | Read Hits: " << cp_we_rd << "\n";
    
    std::cout << "[cp_addr] Unique Addresses Tested: " << cp_addr_bin.size() << "\n";
    std::cout << "[cp_data] Unique Data Values Tested: " << cp_data_bin.size() << "\n";
    
    std::cout << "[cross]   Valid Cross Combinations (CS=1): " << cross_cs1_bin.size() << "\n";
    std::cout << "===================================================\n\n";
}