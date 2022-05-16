// Testbench for SAR DAC
// Change Nbits to match the width of your DAC
// Vin is a normalized voltage between 0 and 100
// Testbench should stop after conversion is complete
// Nice addition would be to loop through different values of Vin
`timescale 1us/100ns
module tb;
  
  localparam NBits= 5;  // Number of bits in DAC
  localparam BitResolution = 100/(2**NBits);
  localparam MaxStates=12+(NBits*6);//# of clock cycles per conv
  localparam Vin = 100; // Integer between Vin = 0 to 100

  
  reg clock, reset;
  reg nStartCnv, compOut;
  wire SH,nEndCnv;
  wire [NBits-1:0] B, dataOut;
  integer jj,Vinput;

 
  
  // Instantiate DUT
  saradc saradcreg(.clock(clock),
                   .reset(reset),
                   .nStartCnv(nStartCnv),
                   .CompOut(compOut),
                   .SH(SH),
                   .nEndCnv(nEndCnv),
                   .B(B),
                   .dataOut(dataOut));

  // Reset and test vectors
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    Vinput=Vin; 
    clock = 0;
    reset = 0;
    nStartCnv = 1;
    compOut = 0;
    #25
    reset = 1;
    #50
    nStartCnv = 0;
    for(jj=0;jj<MaxStates;jj=jj+1)
      begin
      	#50
        if(nEndCnv) nStartCnv=1'b1;
        compOut = comparator(B);  
      end  
    $finish;
  end
  
  // Clock
  always #50 clock = ~clock;

// This function simulates the comparator  
function comparator;
  input [4:0] b;
  begin
    comparator = 1'b1; 
    if(Vinput > b*BitResolution) comparator=1'b0;
  end
endfunction  
endmodule