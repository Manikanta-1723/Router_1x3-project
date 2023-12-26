module router_fsm(input clk, rst, pkt_valid,parity_done, soft_rst_0,soft_rst_1,soft_rst_2,

fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid,

input [1:0]din,

output busy, detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);



//internal variabels



reg [1:0] addr;

reg [1:0] p_state, next_state;



parameter decode_address = 3'b000,

load_first_data = 3'b001,

load_data = 3'b010,

fifo_full_state = 3'b011,

load_after_full = 3'b100,

load_parity = 3'b101,

check_parity_error = 3'b110,

wait_till_empty= 3'b111;



always@(posedge clk)

begin

if(!rst)

addr <=2'b11;

else if

((soft_rst_0 && addr == 2'b00) || (soft_rst_1 && addr == 2'b01) || (soft_rst_2 && addr == 2'b10))

addr <= 2'b11;

else if (detect_add )

addr <= din;

end



// present state logic 



always@(posedge clk) begin

if (!rst)

p_state <= decode_address;

else if 

((soft_rst_0 && addr == 2'b00) || (soft_rst_1 && addr == 2'b01) || (soft_rst_2 && addr == 2'b10))

p_state <= decode_address;

else 

p_state <= next_state;

end



//next_state logic



always @(*)

begin

if(addr==2'b11)

next_state = decode_address ;

else

begin

case(p_state)

decode_address : if(!rst)

next_state = decode_address ;

else if ((pkt_valid &&(din[1:0]==0)&&fifo_empty_0)||(pkt_valid&&(din[1:0]==2'b01)&&fifo_empty_1)||(pkt_valid&&(din[1:0]==2'b10)&&fifo_empty_2))

next_state =load_first_data ;

else if ((pkt_valid &&(din[1:0]==0)&&!fifo_empty_0)||(pkt_valid&&(din[1:0]==2'b01)&&!fifo_empty_1)||(pkt_valid&&(din[1:0]==2'b10)&&!fifo_empty_2))

next_state = wait_till_empty ;

else

next_state =decode_address;

load_first_data :next_state = load_data;



load_data : if (fifo_full)

next_state = fifo_full_state ;

else if (!fifo_full && !pkt_valid )

next_state = load_parity ;

else

next_state = load_data ;



fifo_full_state : if (!fifo_full)

next_state =load_after_full ;

else

next_state = fifo_full_state ;



load_after_full : if (!parity_done && !low_pkt_valid)

next_state =load_data ;

else if (!parity_done && low_pkt_valid)

next_state =load_parity ;

else if (parity_done)

next_state =decode_address ;



load_parity : next_state = check_parity_error ;



check_parity_error : 

if(fifo_full)

next_state =fifo_full_state ;

else if (!fifo_full)

next_state = decode_address ;



wait_till_empty : if ((fifo_empty_0 && addr ==0)||(fifo_empty_1 && addr==1)||(fifo_empty_2 && addr==2))

next_state =load_first_data ;

else

next_state = wait_till_empty ;

endcase

end

end



// output logic



assign lfd_state = (p_state ==load_first_data)?1'b1:1'b0;

assign rst_int_reg = (p_state == check_parity_error)?1:0;

assign full_state = (p_state ==fifo_full)? 1'b1:1'b0;

assign ld_state =(p_state == load_data)?1:0;

assign laf_state = (p_state == load_after_full)?1:0;

assign detect_add =(p_state ==decode_address)?1:0;

assign write_enb_reg = ((p_state ==load_data)||(p_state ==load_after_full)||(p_state==load_parity))?1:0;

assign busy = ((p_state ==load_first_data)||(p_state ==load_parity)||(p_state==load_after_full)||(p_state ==fifo_full_state)||(p_state ==check_parity_error)||(p_state==wait_till_empty))?1:0;



endmodule

