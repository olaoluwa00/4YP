`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2023 12:17:36
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top
#(
parameter WIDTH = 10,
parameter DELAY = 1
)
(
  input clk,            // Clock signal
  input a,              // Input signal
  output b             // Output signal
);

reg [1:0] state;                 // FSM state register
//reg [WIDTH-1:0] ones_register;   // Register of all ones of variable length

reg [WIDTH-1:0] counter;         // Counter register
reg counter_reset, counter_en;   // Counter control signals

reg o;               // Output register

assign next_state = (a && !a2) ? 1'b1 : 1'b0;  // Next state calculation
assign rising_edge = (a1 && !a2);             // Rising edge detection

always @(posedge clk) begin
  counter <= 0;
  if (counter_reset == 1) begin
    counter <= 0;
  end else begin
    if (counter_en == 1)
      counter <= counter + 1;
  end
end

always @(posedge clk) begin
  case(state)
    2'b00: begin  // State 0: Waiting for rising edge
      if(rising_edge) begin
        counter_en <= 1;
        state <= 2'b01;
      end
    end
    2'b01: begin  // State 1: Rising edge detected
      if (counter == WIDTH) begin
        counter_reset <= 1;
        counter_en <= 0;
        o <= 0;
        state <= 2'b00;
      end else begin
        counter_reset <= 0;
        counter_en <= 1;
        o <= 1;
        state <= 2'b01;
      end
    end
    default: state <= 2'b00;
  endcase
end

// Delayed versions of input signal a
reg a1, a2; 
always @(posedge clk) begin
  a2 <= a1;
  a1 <= a;
end

reg [DELAY:0] shift_reg;
always @(posedge clk) begin
    shift_reg[DELAY:1] <= shift_reg[DELAY-1:0];
    shift_reg[0] <= o;
end

assign b = shift_reg[DELAY];



endmodule
