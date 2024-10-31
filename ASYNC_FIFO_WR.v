module ASYNC_FIFO_WR #(

	parameter BUS_WIDTH = 4 // pointer width	
)(

	input 	wire							W_CLK,
	input 	wire							W_RST_N,  	
	input 	wire							W_INC_EN,   
	input 	wire	[BUS_WIDTH-1:0]			syn_gray_R_ptr,   
	
	output 	wire	[BUS_WIDTH-1:0]			gray_W_ptr,		
	output 	reg 	[BUS_WIDTH-1:0]			W_addr,	// binary version
	output 	reg	 							W_FULL
);

///////////////////////////////////////////////////////////////
/////////////////////// W_ptr Calculation /////////////////////
///////////////////////////////////////////////////////////////

always @(posedge W_CLK or negedge W_RST_N) begin 

	if(~W_RST_N) begin
		//gray_W_ptr  <= 0;
		W_addr 		<= 0;
		W_FULL 		<= 0;
	end 
	else if (gray_W_ptr[3] != syn_gray_R_ptr[3] && gray_W_ptr[2] == syn_gray_R_ptr[2] && gray_W_ptr[1:0] == syn_gray_R_ptr[1:0]) begin // full condition
			
		W_FULL <= 1;
	end
	else begin
		W_addr = W_addr + 1;
		W_FULL <= 0;		
	end
end

///////////////////////////////////////////////////////////////
///////////////// Binary to gray Conversion ///////////////////
///////////////////////////////////////////////////////////////

    // The most significant bit (MSB) remains the same
    assign gray_W_ptr[3] = W_addr[3];
    
    // The rest of the bits are calculated as follows:
    assign gray_W_ptr[2] = W_addr[3] ^ W_addr[2];
    assign gray_W_ptr[1] = W_addr[2] ^ W_addr[1];
    assign gray_W_ptr[0] = W_addr[1] ^ W_addr[0];



endmodule : ASYNC_FIFO_WR