module LCD_Driver(CLOCK_50,
						KEY,
						SW,
						LEDG,
						LEDR,
						HEX0,
						HEX1,
						LCD_RW,
						LCD_EN,
						LCD_RS,
						LCD_ON,
						LCD_BLON,
						LCD_DATA);
						
	input CLOCK_50;
	input [3:0] KEY;
	input [8:0] SW;
	
	output [7:0] LEDG;
	output [17:0] LEDR;
	output [6:0] HEX0, HEX1;
	
	output reg LCD_RW, LCD_EN, LCD_RS, LCD_ON, LCD_BLON, LCD_DATA;
	
	wire clk;
	wire first, second;
	reg counter, rs;
	
	//	instantiations
	slowClock sc1( .clkin(CLOCK_50),
						.clkout(clk) );
	
	segDecoder sd1( .value(first),
						 .display(HEX0) );
						 
	segDecoder sd2( .value(second),
						 .display(HEX1) );
	
	// required wires/registers for state machine
	reg [10:0] currentState, nextState;
	
	// state encoding
	localparam resetState1 = 11'd0, resetState2 = 11'd1, resetState3 = 11'd2,
				  resetState4 = 11'd3, resetState5 = 11'd4, resetState6 = 11'd5,
				  state1 = 11'd6, state2 = 11'd7, state3 = 11'd8, state4 = 11'd9,
				  state5 = 11'd10, statePlaceholder = 11'd11;
	
	// constants
	assign LCD_BLON <= 1'b1;
	assign LCD_ON = 1'b1;
	assign LCD_EN = clk;
	assign LCD_RW = 1'b0;
	
	always @(posedge clk) begin
	
		if (KEY[3] == 1'b0) begin
			counter = 1'b0;
			currentState = resetState1;
		end else if (counter == 16) begin
			counter = 1'b0;
			currentState = resetState1;
		end else begin
			currentState = nextState;
			
			if (rs == 1)
				counter = 1'b1;
			end
	end
	 
	// processing state transitions
	always @(*) begin
	
		case(currentState)
			
			resetState1 : begin
				rs = 1'b0;
				LCD_DATA = 8'b00111000;
				LEDG = 8'b0000001;
				nextState = resetState2;
			end
			
			resetState2 : begin
				rs = 1'b0;
				LCD_DATA = 8'b00111000;
				LEDG = 8'b0000010;
				nextState = resetState3;
			end
			
			resetState3 : begin
				rs = 1'b0;
				LCD_DATA = 8'b00001100;
				LEDG = 8'b0000011;
				nextState = resetState4;
			end
			
			resetState4 : begin
				rs = 1'b0;
				LCD_DATA = 8'b00000001;
				LEDG = 8'b0000100;
				nextState = resetState5;
			end
			
			resetState5 : begin
				rs = 1'b0;
				LCD_DATA = 8'b00000110;
				LEDG = 8'b0000101;
				nextState = resetState6;
			end
			
			resetState6 : begin
				rs = 1'b0;
				LCD_DATA = 8'b10000000;
				LEDG = 8'b0000110;
				nextState = state1;
				
				if (SW[0] == 1'b1)
					nextState = state5;
				else
					nextState = state1;
				
			end
			
			state1 : begin
				rs = 1'b1;
				LCD_DATA = 8'b00100001;
				LEDG = 8'b0000111;
				
				if (SW[0] == 1'b1)
					nextState = state5;
				else
					nextState = state2;
				
			end
			
			state2 : begin
				rs = 1'b1;
				LCD_DATA = 8'b01010011;
				LEDG = 8'b00001000;
				
				if (SW[0] == 1'b1)
					nextState = state1;
				else
					nextState = state3;
				
			end
			
			state3 : begin
				rs = 1'b1;
				LCD_DATA = 8'b01100001;
				LEDG = 8'b0001001;
				
				if (SW[0] == 1'b1)
					nextState = state2;
				else
					nextState = state4;
				
			end
			
			state4 : begin
				rs = 1'b1;
				LCD_DATA = 8'b01101110;
				LEDG = 8'b0001010;
				
				if (SW[0] == 1'b1)
					nextState = state3;
				else
					nextState = state5;
				
			end
			
			state5 : begin
				rs = 1'b1;
				LCD_DATA = 8'b01100101;
				LEDG = 8'b0001011;
				
				if (SW[0] == 1'b1)
					nextState = state4;
				else
					nextState = state1;
				
			end
			
		endcase
	
	end	
							
						
endmodule