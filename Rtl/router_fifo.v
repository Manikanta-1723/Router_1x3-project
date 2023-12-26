module router_fifo(din,clk,rst,soft_rst,re,we,lfd,empty,full,dout);

input [7:0] din;

input clk,rst,soft_rst,re,we,lfd;

output empty,full;

output reg [7:0] dout;



integer i;

reg[8:0] mem [15:0];

reg [4:0] wr_ptr;

reg [4:0] rd_ptr;

reg [7:0] counter;

reg lfd_state;



//lfd state 

always@(posedge clk)begin

if(!rst)

lfd_state<= 0;

else 

lfd_state<= lfd;

end



//writing logic

always@(posedge clk)

if(!rst )

begin 

for(i=0; i<16; i=i+1)   //clears memory

mem[i] <= 0;

end

else if (soft_rst==1)

begin 

for(i=0; i<16; i=i+1)

mem[i] <= 0;

end

else begin

if (we ==1 && full ==0)

{mem[wr_ptr[3:0]][8], mem[wr_ptr[3:0]][7:0]} <= {lfd,din};

end 



// read logic

always@(posedge clk )

begin

if (!rst)

dout <= 0;

else if(soft_rst)

dout <= 8'bz;

else begin

if (re ==1 && empty == 0)

dout <= {mem[rd_ptr[3:0]]};

end

end





//write and read pointers

always @(posedge clk)

begin

if (!rst)

begin

wr_ptr <=0;

rd_ptr <=0;

end

else

begin

if (we ==1 && full==0)

wr_ptr <= wr_ptr +1'b1;

if (re ==1 && empty==0)

rd_ptr <= rd_ptr +1'b1 ;

end

end



//counter logic

always@(posedge clk) begin

if(rst ==0 || soft_rst ==1)

counter <= 0;

else if(re ==1 && empty ==0)

begin

if (mem[rd_ptr[3:0]][8]==1'b1)

counter <= mem[rd_ptr[3:0]][7:2]+1'b1 ;  //slicing memory

else if (counter !==0)

counter <= counter -1'b1 ;

end

end



// full and empty 

assign full = ({wr_ptr[4],wr_ptr[3:0]} == {~rd_ptr[4],rd_ptr[3:0]})? 1'b1:1'b0;

assign empty = (wr_ptr == rd_ptr) ? 1'b1 :1'b0;

endmodule
