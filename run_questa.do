vlib work

vlog -f source_file.txt

vsim -voptargs=+acc work.ASYNC_FIFO_TB

add wave *

#add wave -position insertpoint sim:/ASYNC_FIFO_TB/DUT/FIFO_MEM/*

add wave -position insertpoint  \
sim:/ASYNC_FIFO_TB/DUT/FIFO_MEM/W_addr \
sim:/ASYNC_FIFO_TB/DUT/FIFO_MEM/R_addr \
sim:/ASYNC_FIFO_TB/DUT/FIFO_MEM/Fifo_Mem \
sim:/ASYNC_FIFO_TB/DUT/FIFO_MEM/w_clk_en

add wave -position insertpoint  \
sim:/ASYNC_FIFO_TB/DUT/FIFO_WR/syn_gray_R_ptr \
sim:/ASYNC_FIFO_TB/DUT/FIFO_WR/gray_W_ptr

add wave -position insertpoint  \
sim:/ASYNC_FIFO_TB/DUT/FIFO_RD/syn_gray_W_ptr \
sim:/ASYNC_FIFO_TB/DUT/FIFO_RD/gray_R_ptr

run -all