module formula_fsm(clk, tick, trigger, time_out, en_lfsr, start_delay, ledr);

input clk, tick, trigger, time_out;
output en_lfsr, start_delay;
output [9:0] ledr;

reg [1:0] state;
reg led_on, en_lfsr, start_delay;
reg [9:0] ledr;

parameter WAIT_TRIGGER = 2'd0, LIGHT_UP_LEDS = 2'd1, WAIT_FOR_TIMEOUT = 2'd2;

initial 
	begin
		state = WAIT_TRIGGER;
		en_lfsr = 1'b0;
		start_delay = 1'b0;
	end

always @ (posedge clk)
	case(state)
		WAIT_TRIGGER: 
			begin
				if(trigger == 1'b1)
					state <= LIGHT_UP_LEDS;
			end
		LIGHT_UP_LEDS:
				if(ledr == 10'h3ff)
					state <= WAIT_FOR_TIMEOUT;
		WAIT_FOR_TIMEOUT:
				if(time_out == 1'b1)
					 state <= WAIT_TRIGGER;
		default: ;
	endcase

always @ (posedge tick)
	case(state)
		WAIT_TRIGGER:
			ledr = 10'b0;
		LIGHT_UP_LEDS:
			ledr <= {ledr[8:0], 1'b1};
		default:
			ledr <= 10'h3ff;
	endcase
	
always @ (*)
	case(state)
		WAIT_TRIGGER:
			begin

				en_lfsr = 1'b0;
				start_delay = 1'b0;
			end
		LIGHT_UP_LEDS:
			begin
				en_lfsr = 1'b1;
			end
		WAIT_FOR_TIMEOUT:
			begin
				start_delay = 1'b1;
				en_lfsr = 1'b0;
			end
		default: ;
	endcase

endmodule