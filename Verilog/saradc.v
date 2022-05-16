`timescale 1us/100ns
module saradc(
  input clock,reset,
  input nStartCnv,
  input CompOut,
  output reg SH, nEndCnv,
  output reg [4:0] B,
  output reg [4:0] dataOut);
  
  reg [4:0] state;
  
  localparam [4:0]
  sReset = 5'd0,
  sWaitForStart = 5'd1,
  sSample = 5'd2,
  sHold = 5'd3,
  
  sB4High = 5'd4,
  sB4Check = 5'd5,
  sB4Wait = 5'd6,
  sB3High = 5'd7,
  sB3Check = 5'd8,
  sB3Wait = 5'd9,
  sB2High = 5'd10,
  sB2Check = 5'd11,
  sB2Wait = 5'd12,
  sB1High = 5'd13,
  sB1Check = 5'd14,
  sB1Wait = 5'd15,
  sB0High = 5'd16,
  sB0Check = 5'd17,
  sB0Wait = 5'd18,
  
  sStore = 5'd19,
  sDone = 5'd20;
  
  always @(posedge clock or negedge reset)
    begin
      if(reset == 0)
        begin
          state = sReset;
          nEndCnv = 1'b0;
          dataOut = 5'd0;
          SH = 1'b0;
          B = 4'd0;
        end
      else
        begin
          case(state)
            sReset:
              state = sWaitForStart;
            sWaitForStart:
              if(nStartCnv == 0) state = sSample;
            sSample:
              begin
                SH = 1'b1;
                B = 5'b11111;
                nEndCnv = 1'b1;
                state = sHold;
              end
            sHold:
              begin
                SH = 1'b0;
                B = 5'b00000;
                state = sB4High;
              end
            sB4High:
              begin
              	B[4] = 1'b1;
                state = sB4Check;
              end
            sB4Check:
              begin
                if(CompOut) B[4] = 1'b0;
                state = sB4Wait;
              end
            sB4Wait:
              state = sB3High;
            sB3High:
              begin
                B[3] = 1'b1;
                state = sB3Check;
              end
            sB3Check:
              begin
                if(CompOut) B[3] = 1'b0;
                state = sB3Wait;
              end
            sB3Wait:
              state = sB2High;
            sB2High:
              begin
                B[2] = 1'b1;
                state = sB2Check;
              end
            sB2Check:
              begin
                if(CompOut) B[2] = 1'b0;
                state = sB2Wait;
              end
            sB2Wait:
              state = sB1High;
            sB1High:
              begin
                B[1] = 1'b1;
                state = sB1Check;
              end
            sB1Check:
              begin
                if(CompOut) B[1] = 1'b0;
                state = sB1Wait;
              end
            sB1Wait:
              state = sB0High;
            sB0High:
              begin
                B[0] = 1'b1;
                state = sB0Check;
              end
            sB0Check:
              begin
                if(CompOut) B[0] = 1'b0;
                state = sB0Wait;
              end
            sB0Wait:
              state = sStore;
            sStore:
              begin
                dataOut = B;
                state = sDone;
              end
            sDone:
              begin
                nEndCnv = 1'b0;
                state = sWaitForStart;
              end
          endcase
        end
    end
endmodule
            