module GCD (
  input wire CLK,
  input wire RST_N,
  input wire [7:0] A,
  input wire [7:0] B,
  input wire START,
  output reg [7:0] Y,
  output reg DONE,
  output reg ERROR
);

wire found, err;
reg [7:0] reg_a, reg_b, next_a, next_b;
reg [7:0] big_one;
reg error_next;
reg [1:0] state, state_next;

parameter [1:0] IDLE = 2'b00;
parameter [1:0] CALC = 2'b01;
parameter [1:0] FINISH = 2'b10;


always @(posedge CLK) begin
  ERROR <= error_next;
  state <= state_next;
end

//reset after finish and done
always @(posedge CLK) begin
  if(state==IDLE && DONE==1) begin
    Y<=0;
    DONE<=0;
    error_next<=0;
  end
end

//state reg
always @(posedge START) begin
  if(RST_N) begin
    state<=IDLE;
    Y<=0;
    DONE<=0;
    error_next<=0;
    ERROR<=0;
  end
end

//next state logic
always @(posedge CLK) begin
  case(state)
    IDLE:
      if(!START)
        state_next<=IDLE;
      else
        state_next<=CALC;
    CALC:
      if(!found && !ERROR)
        state_next<=CALC;
      else
        state_next<=FINISH;
    default:
      state_next<=IDLE;
  endcase
end


always @(posedge CLK) begin
  if(state==FINISH && found) begin
    Y<=big_one;
    DONE<=1;
    state_next<=IDLE;
  end
end

//load the data
always @(posedge START) begin
  reg_a=A;
  reg_b=B;
end

//check invalid case
always @(posedge START) begin
  if(START && (A==0 || B==0))
    error_next<=1;
end


always@(*) begin
  case(state)
    CALC:
      if(reg_a>reg_b) begin
        reg_a = reg_a - reg_b;
        next_a = reg_a;
        next_b = reg_b;
      end else begin
        reg_b = reg_b - reg_a;
        next_a = reg_a;
        next_b = reg_b;
      end
  endcase
end


always@(*) begin
  if(next_a>next_b)
    big_one=next_a;
  else
    big_one=next_b;
end

assign err = (A == 0 || B == 0);
assign found=(next_a==7'b0 || next_b==7'b0) ? 1'b1 : 1'b0;
endmodule