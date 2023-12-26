module router_fsm_tb();
reg clk,rst,pkt,pkt_valid,parity_done, soft_rst_0,soft_rst_1,soft_rst_2;
reg fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid;
reg [1:0] din;
wire busy, detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;
router_fsm DUT (.clk(clk), .rst(rst), .pkt_valid(pkt_valid), .parity_done(parity_done), .soft_rst_0(soft_rst_0), .soft_rst_1(soft_rst_1),.soft_rst_2(soft_rst_2),
.fifo_full(fifo_full),.fifo_empty_0(fifo_empty_0),.fifo_empty_1(fifo_empty_1),
.fifo_empty_2(fifo_empty_2),.low_pkt_valid(low_pkt_valid), .din(din),
.busy(busy),.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),
.full_state(full_state),.write_enb_reg(write_enb_reg),.rst_int_reg(rst_int_reg),.lfd_state(lfd_state));
//clk generaton 
initial begin
clk = 1'b0;
forever #5 clk =~clk;
end
task initialize(); begin
{fifo_empty_0,fifo_empty_1,fifo_empty_2} = 3'b111;
{pkt_valid, parity_done,din,fifo_full} = 0;
end 
endtask
task reset (); begin
@(negedge clk)
rst = 1'b0;
@(negedge clk)
rst = 1'b1;
end 
endtask
task soft_reset_0(); begin
@(negedge clk )
soft_rst_0 = 1'b1;
@(negedge clk)

soft_rst_0 = 1'b0;
end 
endtask
task soft_reset_1(); begin
@(negedge clk )
soft_rst_1 = 1'b1;
@(negedge clk)
soft_rst_1 = 1'b0;
end 
endtask
task soft_reset_2(); begin
@(negedge clk )
soft_rst_2 = 1'b1;
@(negedge clk)
soft_rst_2 = 1'b0;
end 
endtask
task  DA_LFD_LD_LP_CPE_DA(); begin
pkt_valid = 1'b1; din = 2'b10; fifo_empty_2 = 1'b1;
#40 ;fifo_full = 1'b0;
 pkt_valid = 1'b0;
#30 ; fifo_full = 1'b0;
#20;
end
endtask
task DA_LFD_LD_FFS_LAF_LP_CPE_DA(); begin
pkt_valid = 1'b1; din = 2'b01; fifo_empty_1 = 1'b1;
#40 fifo_full = 1'b1;
#20 fifo_full = 1'b0;
#20 parity_done = 1'b0;
low_pkt_valid = 1'b1;
#30 fifo_full = 1'b0;
end 
endtask
task DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA(); begin
pkt_valid = 1'b1; din = 2'b00; fifo_empty_0 = 1'b1;
#40;
fifo_full = 1'b1;
#40; fifo_full = 1'b0;
#30;
parity_done = 1'b0;
low_pkt_valid = 1'b0;
#40;
fifo_full = 1'b0;
#20;
end
endtask
task DA_LFD_LD_LP_CPE_FFS_LAF_DA(); begin
pkt_valid = 1'b1; din = 2'b10; fifo_empty_2 = 1'b1;
#30;
fifo_full = 0; pkt_valid = 0;
#40;fifo_full = 1'b1;
#20;
fifo_full = 1'b0;
#30;
parity_done = 1;
end
endtask
initial begin 
initialize;
reset;
//DA_LFD_LD_LP_CPE_DA;
DA_LFD_LD_FFS_LAF_LP_CPE_DA;
//DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA;
//DA_LFD_LD_LP_CPE_FFS_LAF_DA
$finish;
end
 endmodule
