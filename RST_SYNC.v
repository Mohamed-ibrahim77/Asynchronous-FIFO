module RST_SYNC # (parameter NUM_STAGES = 2)(

	input 	wire 						CLK,    		// Clock (dest)
	input 	wire						RST,  			// Asynchronous reset active low (dest)
	//input	wire						deasserted_rst,
	output  wire						SYNC_RST
	
);

reg 	[NUM_STAGES-1 : 0]	Stage;

///////////////////////////////////////////////////////////////
///////////////////// Multi Flip Flop Sync ////////////////////
///////////////////////////////////////////////////////////////

always @(posedge CLK or negedge RST) begin 
		
		if(~RST) begin
			//SYNC_RST <= 0;
			Stage <= 0;

		end 
		else begin
			Stage <= {Stage[NUM_STAGES-2 : 0], 1'b1};
		end
end

assign SYNC_RST = Stage[NUM_STAGES-1];

endmodule : RST_SYNC