module router_sync(input detect_add, write_enb_reg, clk, rst,

input read_enb_0, read_enb_1, read_enb_2, empty_0,empty_1,empty_2,

input full_0, full_1, full_2,

input [1:0]din,

output reg[2:0] wr_enb,

output reg fifo_full, soft_rst_0,soft_rst_1,soft_rst_2,

output vld_out_0,vld_out_1,vld_out_2);



// internal variables

reg[4:0] count_0,count_1,count_2;

reg[1:0] temp; 



always@(posedge clk) begin

if (!rst)

temp <= 2'b11;

else

if (detect_add == 1)

temp <= din;

end



// to generate write enable signals

always@(*) begin 

wr_enb = 3'b000;

if (write_enb_reg) begin

if (temp == 2'b00) begin

wr_enb  =3'b001;

fifo_full = full_0;

end

else if ( temp == 2'b01) begin

wr_enb = 3'b010;

fifo_full = full_1;

end

else if (temp == 2'b10) 

wr_enb = 3'b100;

fifo_full = full_2;

end

else 

begin

wr_enb = 3'b000;

fifo_full = 1'b0;

end

end

/*timer logic  and soft reset

for count_0*/

always @(posedge clk)

begin

if(!rst)

begin

count_0<=0 ;

soft_rst_0<=0;

end

else if(vld_out_0)

begin

if (read_enb_0)

begin

soft_rst_0<=0;

count_0<=0 ;

end

else if(!read_enb_0)

begin if (count_0==29)

begin

soft_rst_0 <=1;

count_0 <=0;

end

else

begin

soft_rst_0<=0;

count_0<=count_0+1'b1 ;

end

end

end

end

//for count_1

always @(posedge clk)

begin

if(!rst)

begin

count_1<=0 ;

soft_rst_1<=0;

end

else if(vld_out_1)

begin

if (read_enb_1)

begin

soft_rst_1<=0;

count_1<=0 ;

end

else if(!read_enb_1)

begin if (count_1==29)

begin

soft_rst_1<=1;

count_1<=0;

end

else

begin

soft_rst_1<=0;

count_1<=count_1+1'b1 ;

end

end

end

end



//for count_2

always @(posedge clk)

begin

if(!rst)

begin

count_2<=0 ;

soft_rst_2<=0;

end

else if(vld_out_2)

begin

if (read_enb_2)

begin

soft_rst_2<=0;

count_2<=0 ;

end

else if(!read_enb_2)

begin if (count_2==29)

begin

soft_rst_2<=1;

count_2<=0;

end

else

begin

soft_rst_2<=0;

count_2<=count_2+1'b1 ;

end

end

end

end



// vld_out_ signals



assign vld_out_0 = ~empty_0;

assign vld_out_1 = ~empty_1;

assign vld_out_2 = ~empty_2;



endmodule















