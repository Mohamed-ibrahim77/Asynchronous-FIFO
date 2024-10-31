module ASYNC_FIFO_TB ();

    parameter W_CLK_PERIOD = 10 ;   // 200 MHz
    parameter R_CLK_PERIOD = 40 ;   // 800 MHz
	
	parameter DATA_WIDTH = 8; 
	parameter BUS_WIDTH = 4; 		// pointer width
	parameter MEM_DEPTH = 8; 		// fifo depth

	reg		 						R_CLK_TB;   
	reg		 						R_RST_N_TB;   
	reg		 						R_INC_EN_TB;   
	
	reg								W_CLK_TB; 	
	reg								W_RST_N_TB;  	
	reg								W_INC_EN_TB;   
	reg		[DATA_WIDTH-1 : 0]		W_DATA_TB;

	wire 							W_FULL_TB;
	wire 							R_EMPTY_TB;
	wire 	[DATA_WIDTH-1 : 0]		R_DATA_TB;

	// module instantiation
	ASYNC_FIFO_TOP DUT (
	.W_CLK   (W_CLK_TB),
	.W_RST_N (W_RST_N_TB),
	.W_INC_EN(W_INC_EN_TB),
	.W_FULL  (W_FULL_TB),
	.W_DATA  (W_DATA_TB),
	.R_CLK   (R_CLK_TB),
	.R_RST_N (R_RST_N_TB),
	.R_INC_EN(R_INC_EN_TB),
	.R_EMPTY (R_EMPTY_TB),
	.R_DATA  (R_DATA_TB)
	);

	// writing domain Clock Generator 
	always #(W_CLK_PERIOD/2) W_CLK_TB = ~W_CLK_TB ;

	// Reading domain Clock Generator 
	always #(R_CLK_PERIOD/2) R_CLK_TB = ~R_CLK_TB ;


///////////////////////////////////////////////////////////////
//////////////////////// Writing domain ///////////////////////
///////////////////////////////////////////////////////////////

	initial begin
		
		// Initialize inputs
		W_CLK_TB     = 1;	
	    W_RST_N_TB   = 0;
	    W_INC_EN_TB  = 0;

	    // deassert reset
	    #(W_CLK_PERIOD)  W_RST_N_TB = 1;
	    				 W_INC_EN_TB = 1;
	    
	    #(W_CLK_PERIOD)  W_DATA_TB = 8'ha2;    
	    #(W_CLK_PERIOD)  W_DATA_TB = 8'h02;    
	    #(W_CLK_PERIOD)  W_DATA_TB = 8'h04;    
	    #(W_CLK_PERIOD)  W_DATA_TB = 8'h06;    
	    #(W_CLK_PERIOD)  W_DATA_TB = 8'h08;    
	    #(W_CLK_PERIOD)  W_DATA_TB = 8'h0a;    

	    // Finish simulation
	    //#200;
	    //$stop;
	end

///////////////////////////////////////////////////////////////
//////////////////////// Reading domain ///////////////////////
///////////////////////////////////////////////////////////////

	initial begin

		// Initialize inputs
		R_CLK_TB     = 1;	
	    R_RST_N_TB   = 0;
	    R_INC_EN_TB  = 0;

	    // deassert reset
	    #(R_CLK_PERIOD)  R_RST_N_TB = 1;
	    				 R_INC_EN_TB = 1;
	    
	    //#(W_CLK_PERIOD)  R_DATA = 8'b10101010;    
	    
	    // Finish simulation
	    #200;
	    $stop;
	end

endmodule : ASYNC_FIFO_TB