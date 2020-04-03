///////////////////////////////////////////////////////////////// 
// Author - Imants Pulkstenis
// Date - 04.04.2020
// Project name - Audio FFT on FPGA
// Module name - JXADC PMOD connector output
//
// Detailed module description:
// This module outputs signals to JXADC PMOD
// where logic analyzer are conected.
// Port is connected to logic analizer
//
// Revision:
// A - initial design
// B - 
// C - 
//
///////////////////////////////////////////////////////////////////


module JXADC_controler (
    input           ch0,
    input           ch1,
    input           ch2,
    input           ch3,
    input           ch4,
    input           ch5,
    input           ch6,
    input           ch7,
    output  [7: 0]  JXADC       // output for logic analizer   
    );

assign JXADC = {ch7,ch6,ch5,ch4,ch3,ch2,ch1,ch0}; 

endmodule