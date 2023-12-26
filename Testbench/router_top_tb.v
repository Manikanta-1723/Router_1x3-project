module router_top_tb();
reg clk ,rst,re_0,re_1,re_2,pkt_valid;
reg [7:0] din;
wire err,busy,vld_out_0,vld_out_1,vld_out_2;
wire [7:0] data_out_0,data_out_1,data_out_2;
router_top DUT
(.clk(clk),.rst(rst),.re_0(re_0),.re_1(re_1),.re_2(re_2),.pkt_valid(pkt_valid),
.din(din),.err(err),.busy(busy),.vld_out_0(vld_out_0),.vld_out_1(vld_out_1),.vld_out_2(vld_out_2),
.data_out_0(data_out_0),.data_out_1(data_out_1),.data_out_2(data_out_2));

reg [7:0] internal_parity ;
initial begin
clk = 1'b0;
forever #5 clk = ~clk;
end

task initialize ;
begin
rst=1'b1 ;
{clk,re_0,re_1,re_2}=0;
end
endtask
task reset() ;
begin
@(negedge clk)
rst =1'b0;
@(negedge clk)
rst =1'b1;
end
endtask
task header (input[7:0] a);
begin
internal_parity =0;
@(negedge clk)
begin
din =a;
pkt_valid=1'b1;
internal_parity = internal_parity^din;
end
end
endtask
task payload (input [5:0] len);
integer i;
begin
i=0;
while (i<len)
begin
@(negedge clk)
if(busy==0)
begin
din ={$random}%256;
i=i+1;
internal_parity=internal_parity ^ din ;
end
else
begin
wait(!busy)
@(negedge clk)
din = {$random}%256;
internal_parity =internal_parity ^ din ;
end
end
end
endtask
task parity ;
begin
@(negedge clk)
if(busy==0)
begin
pkt_valid =0;
din =internal_parity;
end
else
begin
wait(!busy)
@(negedge clk);
pkt_valid =0;
din =internal_parity ;
end
end
endtask


task packet_10;
begin
header(8'b00101010);
@(negedge clk)
payload (6'd10);
parity;
end
endtask

task packet_14;
begin
header(8'b00111001);
@(negedge clk)
payload(6'd14);
parity ;
end
endtask

task packet_32;
begin
header(8'b10000000);
@(negedge clk)
payload(6'd32);
parity ;
end
endtask
always @(vld_out_0)
begin
if(vld_out_0)
begin
#10;
@(negedge clk)
re_0 <=1;
end
else
begin
@(negedge clk)
re_0 <=0;
end
end
always @(vld_out_1)
begin
if(vld_out_1)
begin
#10;
@(negedge clk)
re_1 <=1;
end
else
begin
@(negedge clk)
re_1 <=0;
end
end
always @(vld_out_2)
begin
if(vld_out_2)
begin
#10;
@(negedge clk)
re_2 <=1;
end
else
begin
@(negedge clk)
re_2 <=0;
end
end

initial begin
initialize;
reset;
packet_10;
#50;
packet_32;
#50;
packet_14;
#850;
$finish ;
end
endmodule

