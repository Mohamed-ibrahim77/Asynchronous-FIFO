module ASYNC_FIFO_MEM_CTRL #(

	parameter DATA_WIDTH = 8,
	parameter MEM_DEPTH = 8,
	parameter BUS_WIDTH = 4 // pointer width	
	)

	(

	input 	wire							W_CLK,
	input 	wire							W_INC_EN,   
	input 	wire	[DATA_WIDTH-1 : 0]		WR_DATA,
	input 	wire 							W_FULL,
	input 	wire 	[BUS_WIDTH -1 : 0]		W_addr,

	//input 	wire							R_CLK, 	
	//input 	wire							R_RST_N,  		 	
	//input 	wire							R_INC_EN,   
	//input 	wire 							R_EMPTY,
	input 	wire 	[BUS_WIDTH -1 : 0]		R_addr,
	
	output 	wire		[DATA_WIDTH-1 : 0]		R_DATA

);
	
	reg 	[DATA_WIDTH-1 : 0]		Fifo_Mem 	[0 : MEM_DEPTH-1]; 	

///////////////////////////////////////////////////////////////
//////////////////////// writing domain ///////////////////////
///////////////////////////////////////////////////////////////

	wire 							w_clk_en;

	assign w_clk_en = W_INC_EN & (~W_FULL);

always @(posedge W_CLK) begin 
	
	if(w_clk_en) begin
		
		Fifo_Mem[W_addr] <= WR_DATA;
	end 

end


///////////////////////////////////////////////////////////////
//////////////////////// reading domain ///////////////////////
///////////////////////////////////////////////////////////////

/*	wire 							r_clk_en;

	assign r_clk_en = R_INC_EN & (~R_EMPTY);

always @(posedge R_CLK or R_RST_N) begin 
	
	if (~R_RST_N) begin
		R_DATA <= 0;
	end
	else if(r_clk_en) begin
		
		R_DATA <= Fifo_Mem[R_addr];
	end 

end
*/
assign	R_DATA = Fifo_Mem[R_addr];


endmodule : ASYNC_FIFO_MEM_CTRL