module ASYNC_FIFO_RD #(

	parameter BUS_WIDTH = 4 // pointer width	
)(
	
	input 	wire							R_CLK,
	input 	wire							R_RST_N,  	
	input 	wire							R_INC_EN,   
	input 	wire	[BUS_WIDTH-1:0]			syn_gray_W_ptr,   
	
	output 	wire	[BUS_WIDTH-1:0]			gray_R_ptr,		
	output 	reg 	[BUS_WIDTH-1:0]			R_addr,	// binary version
	output 	reg	 							R_EMPTY
);

///////////////////////////////////////////////////////////////
/////////////////////// R_ptr Calculation /////////////////////
///////////////////////////////////////////////////////////////

always @(posedge R_CLK or negedge R_RST_N) begin 

	if(~R_RST_N) begin
		//gray_R_ptr  <= 0;
		R_addr 		<= 0;
		R_EMPTY 	<= 0;
	end 
	else if (gray_R_ptr == syn_gray_W_ptr) begin // EMPTY condition
			
		R_EMPTY <= 1;
	end
	else begin
		R_addr = R_addr + 1;
		R_EMPTY <= 0;		
	end
end

///////////////////////////////////////////////////////////////
///////////////// Binary to gray Conversion ///////////////////
///////////////////////////////////////////////////////////////

    // The most significant bit (MSB) remains the same
    assign gray_R_ptr[3] = R_addr[3];
    
    // The rest of the bits are calculated as folloRs:
    assign gray_R_ptr[2] = R_addr[3] ^ R_addr[2];
    assign gray_R_ptr[1] = R_addr[2] ^ R_addr[1];
    assign gray_R_ptr[0] = R_addr[1] ^ R_addr[0];


endmodule : ASYNC_FIFO_RD