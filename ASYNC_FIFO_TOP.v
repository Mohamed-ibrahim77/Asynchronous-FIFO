module ASYNC_FIFO_TOP #(

	parameter DATA_WIDTH = 8, 
	parameter BUS_WIDTH = 4, // pointer width
	parameter MEM_DEPTH = 8  // fifo depth
	)
	(

	input 	wire		 					R_CLK,   
	input 	wire		 					R_RST_N,   
	input 	wire		 					R_INC_EN,   
	
	input 	wire							W_CLK, 	
	input 	wire							W_RST_N,  	
	input 	wire							W_INC_EN,   
	input 	wire	[DATA_WIDTH-1 : 0]		W_DATA,

	output 	wire 							W_FULL,
	output 	wire 							R_EMPTY,
	output 	wire 	[DATA_WIDTH-1 : 0]		R_DATA

);

///////////////////////////////////////////////////////////////
////////////////////////// W_RST_SYNC /////////////////////////
///////////////////////////////////////////////////////////////
/*
	wire			syn_W_rst_wire;

RST_SYNC	 W_RST_SYN	(
.CLK           (W_CLK),
.RST           (W_RST_N),
//.deasserted_rst(deasserted_rst),
.SYNC_RST      (syn_W_rst_wire)
);

///////////////////////////////////////////////////////////////
////////////////////////// R_RST_SYNC /////////////////////////
///////////////////////////////////////////////////////////////

	wire			syn_R_rst_wire;

RST_SYNC	 R_RST_SYN	(
.CLK           (R_CLK),
.RST           (R_RST_N),
//.deasserted_rst(deasserted_rst),
.SYNC_RST      (syn_R_rst_wire)
);
*/
///////////////////////////////////////////////////////////////
////////////////////// ASYNC_FIFO_MEM_CTRL ////////////////////
///////////////////////////////////////////////////////////////

	wire	[BUS_WIDTH -1:0]		W_addr_wire;
	wire	[BUS_WIDTH -1:0]		R_addr_wire;

ASYNC_FIFO_MEM_CTRL #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH), .BUS_WIDTH(BUS_WIDTH))	FIFO_MEM (
.W_CLK   (W_CLK),
.W_INC_EN(W_INC_EN),
.W_FULL  (W_FULL),
.WR_DATA (W_DATA),
.W_addr  (W_addr_wire),
//.R_CLK   (R_CLK),		//
//.R_RST_N (R_RST_N),		//
//.R_EMPTY (R_EMPTY),		//
//.R_INC_EN(R_INC_EN),	//
.R_addr  (R_addr_wire),	
.R_DATA  (R_DATA)
);



///////////////////////////////////////////////////////////////
///////////////////////// ASYNC_FIFO_WR ///////////////////////
///////////////////////////////////////////////////////////////

	wire	[BUS_WIDTH -1:0]		syn_gray_R_ptr_wire;
	wire	[BUS_WIDTH -1:0]		gray_W_ptr_wire;

ASYNC_FIFO_WR #(.BUS_WIDTH(BUS_WIDTH))	FIFO_WR	(
.W_CLK         (W_CLK),
.W_RST_N       (W_RST_N),
.W_INC_EN      (W_INC_EN),
.W_FULL        (W_FULL),
.W_addr        (W_addr_wire),
.syn_gray_R_ptr(syn_gray_R_ptr_wire),
.gray_W_ptr    (gray_W_ptr_wire)
);


/*************************************************************/


///////////////////////////////////////////////////////////////
///////////////////////// ASYNC_FIFO_RD ///////////////////////
///////////////////////////////////////////////////////////////

	wire	[BUS_WIDTH -1:0]		syn_gray_W_ptr_wire;	// in
	wire	[BUS_WIDTH -1:0]		gray_R_ptr_wire; 		// out

ASYNC_FIFO_RD #(.BUS_WIDTH(BUS_WIDTH))	FIFO_RD	(
.R_CLK         (R_CLK),
.R_RST_N       (R_RST_N),
.R_INC_EN      (R_INC_EN),
.R_EMPTY       (R_EMPTY),
.R_addr        (R_addr_wire),
.syn_gray_W_ptr(syn_gray_W_ptr_wire),
.gray_R_ptr    (gray_R_ptr_wire)
);

///////////////////////////////////////////////////////////////
/////////////////////////// SYNC_R2W //////////////////////////
///////////////////////////////////////////////////////////////

BIT_SYNC #(.NUM_STAGES(2), .BUS_WIDTH(BUS_WIDTH))	SYNC_R2W (
.CLK  (W_CLK),
.RST  (W_RST_N),
.ASYNC(gray_R_ptr_wire),
.SYNC (syn_gray_R_ptr_wire)
);

///////////////////////////////////////////////////////////////
/////////////////////////// SYNC_W2R //////////////////////////
///////////////////////////////////////////////////////////////

BIT_SYNC #(.NUM_STAGES(2), .BUS_WIDTH(BUS_WIDTH))	SYNC_W2R (
.CLK  (R_CLK),
.RST  (R_RST_N),
.ASYNC(gray_W_ptr_wire),
.SYNC (syn_gray_W_ptr_wire)
);


endmodule : ASYNC_FIFO_TOP