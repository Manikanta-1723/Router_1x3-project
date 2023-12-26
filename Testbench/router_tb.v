module router_fifo_tb ();
reg clk ,rst ,we ,re ,soft_rst ,lfd;
reg [7:0]din ;
wire empty ,full;
wire [7:0] dout;
integer j;
router_fifo DUT
(clk(clk),.rst(rst),.we(we),.re(re),.soft_rst(soft_rst),.lfd(lfd),.din(din),.empty(empty),.full(full),.dout(dout));
initial begin
clk=0;
forever#5
clk=~clk;
end
task reset() ;
begin
@(negedge clk)
rst =1'b0;
@(negedge clk)
rst =1'b1;
end
endtask
task soft_reset ();
begin
@(negedge clk)
soft_rst =1'b1;
@(negedge clk)
soft_rst =1'b0;
end
endtask



task write ();
reg [7:0]payload ,parity,header ;
reg [5:0]payload_len ;
reg [1:0] addrs ;
begin
@(negedge clk)
addrs = 2'b11;
payload_len =6'd14;
lfd =1'b1;
we =1'b1;
header ={payload_len ,addrs};
din = header;
for(j=0;j<payload_len;j=j+1)
begin
@(negedge clk)
lfd =1'b0;
we =1'b1;
payload = {$random}%256 ;
din =payload ;
end
@(negedge clk)
lfd =1'b0;
we =1'b1;
parity = {$random}%256 ;
din = parity;
end
endtask
task read ();
begin
re =1'b1;
end
endtask


initial
begin
reset;
soft_reset;
write;
#30;
read;
#300;
$finish;
end
initial
$monitor("clk=%b,rst=%b,we=%b,re=%b,din=%b,lfd=%b,dout%b,full=%b,empty=%b",clk,rst,we,re,din,lfd,dout,full,empty);
endmodule
