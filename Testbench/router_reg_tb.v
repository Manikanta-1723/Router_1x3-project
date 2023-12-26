module router_reg_tb ();
reg clk,rst,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
reg [7:0]din;
wire parity_done ,low_pkt_valid,err ;
wire [7:0] dout;
router_reg  DUT
(.clk(clk),.rst(rst),.pkt_valid(pkt_valid),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),
.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),
.lfd_state(lfd_state),.din(din),.dout(dout),.parity_done(parity_done),.low_pkt_valid(low_packet_valid),.err(err));
initial begin
clk= 1'b0;
forever #5 clk=~clk;
end
task reset() ;
begin
@(negedge clk)
rst =1'b0;
@(negedge clk)
rst =1'b1;
end
endtask
task initialize ();
begin
pkt_valid =1'b0;
fifo_full =1'b0;
rst_int_reg =1'b0;
detect_add =1'b0;
ld_state =1'b0;
laf_state =1'b0;
full_state =1'b0;
lfd_state =1'b0;
end endtask

task inputs (input [7:0]d);
begin
din =d;
end
endtask
task packet_data ;
begin
@(negedge clk)
pkt_valid <=1'b1;
detect_add <= 1'b1;
inputs(8'b00101000);
@(negedge clk)
detect_add <= 1'b0;
lfd_state <=1'b1;
@(negedge clk)
fifo_full <=1'b0;
lfd_state <= 1'b0;
ld_state <=1'b1;
repeat (6)
begin
inputs({$random}%256);
end
@(negedge clk)
fifo_full <=1'b1;
inputs({$random}%256);
@(negedge clk)
ld_state <= 1'b0;
full_state <= 1'b1;
@(negedge clk)
fifo_full <=1'b0;
full_state <= 1'b0;
laf_state <=1'b1;
@(negedge clk)
ld_state <=1;
laf_state <=0;
pkt_valid <=0;
inputs({$random}%256);
@(negedge clk)
ld_state <= 0;
rst_int_reg <=1;
end
endtask
initial begin
initialize ;
reset;
packet_data;
#200;
$finish;
end
endmodule
