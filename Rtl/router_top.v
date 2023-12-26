 module router_top(input clk, rst, read_enb_0,read_enb_1,read_enb_2,pkt_valid,

 input [7:0]din,

 output err,busy,vld_out_0,vld_out_1,vld_out_2,

 output [7:0]data_out_0,data_out_1,data_out_2);

 

 wire soft_rst_0,soft_rst_1,soft_rst_2,full_0,full_1,full_2,empty_0,empty_1,empty_2,

 fifo_full,detect_add, ld_state,laf_state,full_state,lff_state,rst_int_reg,parity_done,low_pkt_valid,write_enb_reg;

 

 //internal variables

 wire [2:0] write_enb;

 wire [7:0] d_in; 

 

 //fsm module

 router_fsm FSM1 

 (.clk(clk),.rst(rst),.pkt_valid(pkt_valid),.parity_done(parity_done),.soft_rst_0(soft_rst_0),.soft_rst_1(soft_rst_1),.soft_rst_2(soft_rst_2),

 .fifo_full(fifo_full),.fifo_empty_0(empty_0),.fifo_empty_1(empty_1),.fifo_empty_2(empty_2),.low_pkt_valid(low_pkt_valid),.din(din[1:0]),

 .busy(busy),.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.write_enb_reg(write_enb_reg),

 .rst_int_reg(rst_int_reg),.lfd_state(lfd_state));

 

 //syncronizer module 

 router_sync SYNCRONIZER

 (.detect_add(detect_add),.write_enb_reg(write_enb_reg),.clk(clk),.rst(rst),.full_0(full_0),.full_1(full_1),.full_2(full_2),

 .read_enb_0(read_enb_0),.read_enb_1(read_enb_1),.read_enb_2(read_enb_2),.empty_0(empty_0),.empty_1(empty_1),.empty_2(empty_2),

 .din(din[1:0]),.wr_enb(write_enb),.fifo_full(fifo_full),.soft_rst_0(soft_rst_0),.soft_rst_1(soft_rst_1),.soft_rst_2(soft_rst_2),

.vld_out_0(vld_out_0),.vld_out_1(vld_out_1),.vld_out_2(vld_out_2));

 

 //fifo FIFO_0 module 

 router_fifo FIFO_0

 (.clk(clk),.rst(rst),.we(write_enb_0),.re(re_enb_0),.soft_rst(soft_rst_0),.lfd(lfd_state),.din(d_in),.empty(empty_0),.full(full_0),.dout(data_out_0));

 

 //fifo FIFO_1 module 

 router_fifo FIFO_1

 (.clk(clk),.rst(rst),.we(write_enb_1),.re(re_enb_1),.soft_rst(soft_rst_1),.lfd(lfd_state),.din(d_in),.empty(empty_1),.full(full_1),.dout(data_out_1));

 

 //fifo FIFO_2 module 

 router_fifo FIFO_2

 (.clk(clk),.rst(rst),.we(write_enb_2),.re(re_enb_2),.soft_rst(soft_rst_2),.lfd(lfd_state),.din(d_in),.empty(empty_2),.full(full_2),.dout(data_out_2));

 

 //register module

 router_reg REGISTER

 (.clk(clk),.rst(rst),.pkt_valid(pkt_valid),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),

.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.

lfd_state(lfd_state),.din(d_in),.dout(d_in),.parity_done(parity_done),.low_pkt_valid(low_pkt_valid),.err(err));





endmodule