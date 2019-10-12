/*
//////////////////////////////////////////////////////////////////
//
// How do I use the Fully Open Source iCE40 Flow?
// Synthesis for iCE40 FPGAs can be done with Yosys. 
// Place-and-route can be done with arachne-pnr. 
// Here is an example script for implementing and 
// programming the rot example from arachne-pnr 
// (this example targets the iCEstick development board):
//
///////////////////////////////////////////////////////////////////

    yosys -p "synth_ice40 -blif output.blif" blockram.v
    arachne-pnr -d 1k -p output.pcf output.blif -o output.asc
    icepack output.asc output.bin
    iceprog output.bin

A simple timing analysis report can be generated using the icetime
utility:

    icetime -tmd hx1k rot.asc

///////////////////////////////////////////////////////////////
For Go Board 
    
    yosys  -p "read_verilog blockram.v; synth_ice40 -blif output.blif"
    arachne-pnr -d 1k -p constraints.pcf -P vq100 -o output.asc output.blif
    icepack output.asc output.bin
    icetime -d hx1k output.asc
    iceprog output.bin

*/

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                      Icarus Verilog                              //
//   http://iverilog.wikia.com/wiki/Main_Page                       //
//////////////////////////////////////////////////////////////////////
/*
    // Do this in your test bench

    always #1 r_Clock <= ~r_Clock; 

  initial
  begin
    #2_000;
    $finish();
  end
    
  initial 
  begin 
    $display(" ");
    $display("----------------------------------------------");
    $display("          Starting Testbench...");
    $dumpfile("wave.vcd");
    $dumpvars(0);
    $display("----------------------------------------------");
    $display(" ");
  end


Code:
    iverilog -o output.vvp clock_enable_tb.v
    vvp output.vvp
    gtkwave -f wave.vcd

Or one line:
iverilog -o output.vvp top_tb.v && vvp output.vvp && gtkwave -f wave.vcd
    

*/
/////////////////////////////////////////////////////
//
//  Serial comunication: Linux
//  
//  stty -F /dev/ttyUSB1 115200  # set speed
//  screen /dev/ttyUSB1 115200  # set spped
//
//
//  minicom         # -s ender setup screen
//                  # minicom can send file
////////////////////////////////////////////////////

