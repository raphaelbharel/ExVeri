module ex9_top(
CLOCK_50,
KEY,
HEX0,
HEX1,
HEX2,
HEX3,
HEX4,
LEDR);

	input CLOCK_50;
	input [3:0] KEY;
	
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4;
	output [9:0] LEDR;
	
	wire TICK_1MS, TICK_500MS;
	wire time_out;
	wire en_lfsr, start_delay;
	wire [6:0] prbs;
	wire [3:0] BCD0, BCD1, BCD2, BCD3, BCD4;
	wire count_over, start_count,reset_count;
	wire [15:0] reaction_time;
	
	clk_16_tick TICK1(CLOCK_50, TICK_1MS);
	clk500 TICK500(TICK_1MS,TICK_500MS);
	lfsr_7 RDMGEN(en_lfsr, TICK_1MS, prbs);

	//fsm_light FSM(TICK_1MS, TICK_500MS, ~KEY[3], time_out, en_lfsr, start_delay, LEDR[9:0]);
	
	fsm_reaction FSM(TICK_1MS, TICK_500MS, ~KEY[3], time_out, count_over, en_lfsr, start_delay, start_count, reset_count, LEDR[9:0]);
	
	//Random delay generation
	delay DELAY(TICK_1MS, start_delay,(prbs*125),time_out);
	
	count REACTION_TIME(TICK_1MS, ~KEY[0], start_count, reset_count, reaction_time, count_over);
	
	//count(clk, KEY, trigger, reaction_time, count_over);
	
	//Number conversions for 7 seg display
	bin2bcd_16(reaction_time,BCD0, BCD1, BCD2, BCD3, BCD4);
	hex_to_7seg SEG0(HEX0,BCD0);
	hex_to_7seg SEG1(HEX1,BCD1);
	hex_to_7seg SEG2(HEX2,BCD2);
	hex_to_7seg SEG3(HEX3,BCD3);
	hex_to_7seg SEG4(HEX4,BCD4);

endmodule
	

