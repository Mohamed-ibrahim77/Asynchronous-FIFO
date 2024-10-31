module DATA_SYNC # (parameter NUM_STAGES = 2, BUS_WIDTH = 4)(
	
	input 	wire 						CLK,    		// Clock (dest)
	input 	wire						src_bus_enable, // unsync src Enable
	input 	wire						RST,  			// Asynchronous reset active low (dest)
	input 	wire	[BUS_WIDTH-1 : 0]	Unsync_bus_in,

	output  reg							dest_enable_pulse,
	output 	reg		[BUS_WIDTH-1 : 0]	sync_bus_out
);

reg 	[NUM_STAGES-1 : 0]	Stage;
wire 						sync_src_bus_enable;

///////////////////////////////////////////////////////////////
///////////////////// Multi Flip Flop Sync ////////////////////
///////////////////////////////////////////////////////////////

always @(posedge CLK or negedge RST) begin 
		
		if(~RST) begin
			//dest_enable_pulse <= 0;
			//sync_bus_out <= 0;
			Stage <= 0;

		end 
		else begin
			Stage <= {Stage[NUM_STAGES-2 : 0], src_bus_enable};
		end
end

assign sync_src_bus_enable = Stage[NUM_STAGES-1];

///////////////////////////////////////////////////////////////
/////////////////////// Pulse Generator ///////////////////////
///////////////////////////////////////////////////////////////

reg 						Generated_pulse_temp;
wire						Generated_pulse;

always @(posedge CLK or negedge RST) begin 
	
	if(~RST) begin
		Generated_pulse_temp <= 0;
	end 
	else begin
		Generated_pulse_temp <= sync_src_bus_enable;
	end
end

assign Generated_pulse = ~Generated_pulse_temp & sync_src_bus_enable;

always @(posedge CLK or negedge RST) begin 
	
	if(~RST) begin
		dest_enable_pulse <= 0;
	end 
	else begin
		dest_enable_pulse <= Generated_pulse;
	end
end

///////////////////////////////////////////////////////////////
////////////////// MUX-Select Synchronization /////////////////
///////////////////////////////////////////////////////////////

wire 						mux_out;

assign mux_out = (Generated_pulse)? Unsync_bus_in : sync_bus_out ;

always @(posedge CLK or negedge RST) begin 
	
	if(~RST) begin
		sync_bus_out <= 0;
	end 
	else begin
		sync_bus_out <= mux_out;
	end
end

endmodule : DATA_SYNC