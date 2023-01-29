module example(
  input clk,
  input rst,
  output [15:0] LED
);
  parameter sec = 100000000 - 1;

  reg [31:0] counter;
  reg [31:0] counter_next;
  
  reg led_state;
  reg led_state_next;

  assign LED = {16{led_state}};

  always @(posedge clk, posedge rst) begin
    if (rst == 1) begin
      counter <= 0;
      led_state <= 0;
    end else begin
      counter <= counter_next;
      led_state <= led_state_next;
    end
  end

  always @(*) begin
    if (counter == sec) begin
      led_state_next = ~led_state;
      counter_next = 0;
    end else begin
      led_state_next = led_state;
      counter_next = counter + 1;
    end
  end
endmodule