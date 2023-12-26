module router_sync_tb();
reg detect_add, write_enb_reg, clk, rst;
reg read_enb_0, read_enb_1, read_enb_2, empty_0,empty_1,empty_2;
reg full_0, full_1, full_2;
reg [1:0]din;
wire [2:0] wr_enb;
wire fifo_full, soft_rst_0,soft_rst_1,soft_rst_2 ;
wire vld_out_0,vld_out_1,vld_out_2;
router_sync DUT (.detect_add(detect_add),.write_enb_reg(write_enb_reg),.clk(clk),.rst(rst),
.full_0(full_0),.full_1(full_1),.full_2(full_2), .read_enb_0(read_enb_0),.read_enb_1(read_enb_1),  .read_enb_2(read_enb_2),.empty_0(empty_0),.empty_1(empty_1),.empty_2(empty_2),.din(din),.wr_enb(wr_enb),.fifo_full(fifo_full),.soft_rst_0(soft_rst_0),.soft_rst_1(soft_rst_1),.soft_rst_2(soft_rst_2),.vld_out_0(vld_out_0),.vld_out_1(vld_out_1),.vld_out_2(vld_out_2));
initial begin 
clk = 1'b0; forever #5 clk = ~clk;
end
task initialize ();
begin 
{empty_0, empty_1, empty_2} = 3'b111;
{detect_add, din, write_enb_reg,read_enb_0,read_enb_1,read_enb_2,full_0,full_1,full_2}=0;
end
endtask
task reset(); begin
@(negedge clk)
rst = 1'b0;
@(negedge clk)
rst = 1'b1;
end
endtask
task inputs(input [1:0] data);
begin
@(negedge clk)

din = data;
end
endtask
initial begin
initialize;
reset ;
inputs (2'b10);
detect_add = 1'b1;
write_enb_reg =1'b1 ;
//reset;
//inputs(2'b00);
empty_2= 1'b0;
read_enb_2 =1'b0;
full_2 =1'b1 ;
//reset;
//inputs(2'b01);
//empty_1=1'b1;
#1000;
read_enb_2 =1'b1;
#50;
$finish;
end
initial
$monitor("clk=%b,rst=%b,din=%b,detect_add=%b,write_enb_reg=%b,empty_0=%b,empty_1=%b,read_enb_0=%b,read_enb_1=%b,soft_rst_0=%b,soft_rst_1=%b,soft_rst_2=%b",clk,rst,din,detect_add,write_enb_reg,empty_0,empty_1,read_enb_0,read_enb_1,soft_rst_0,soft_rst_1,soft_rst_2);
endmodule
