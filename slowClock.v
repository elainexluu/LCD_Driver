module slowClock(clkin, clkout);

	input clkin;
	output reg clkout;
	
	parameter counter = 26;
	reg [25:0] sCounter;
	
	
	always @(posedge clkin) begin
		sCounter <= sCounter + 1;
		
		if (sCounter == counter-1) begin
			clkout = ~clkout;
			sCounter <= 0;
		end
		
	end

endmodule