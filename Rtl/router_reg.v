module router_reg (input

clk,rst,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,

input [7:0]din,

output reg parity_done ,low_pkt_valid,err,

output reg [7:0] dout );

reg [7:0] hold_header_byte ,fifo_full_state_byte ,internal_parity,packet_parity_byte ;

always @(posedge clk)

begin

if(!rst)

parity_done <=1'b0;

else

begin

if (ld_state && !fifo_full && !pkt_valid)

parity_done <=1'b1;

else if (laf_state && low_pkt_valid && !parity_done)

parity_done <= 1'b1;

else

begin

if(detect_add)

parity_done <= 1'b0;

end

end

end

always @(posedge clk)

begin

if (!rst)

low_pkt_valid <=1'b0;

else

begin

if (rst_int_reg)

low_pkt_valid <=1'b0;

if (ld_state ==1 && pkt_valid ==0)

low_pkt_valid <= 1'b1;

end

end

always @(posedge clk)

begin

if(!rst)

dout <= 8'b0;

else

begin

if(detect_add && pkt_valid)

hold_header_byte <= din;

else if (lfd_state)

dout <= hold_header_byte ;

else if (ld_state && !fifo_full)

dout <=din;

else if (ld_state && fifo_full)

fifo_full_state_byte <= din ;

else

begin

if (laf_state)

dout <=fifo_full_state_byte;

end

end

end

always @(posedge clk)

begin

if(!rst)

internal_parity <= 8'b0;

else if (lfd_state)

internal_parity <= internal_parity ^ hold_header_byte;

else if (ld_state && pkt_valid)

internal_parity <= internal_parity ^ din ;

else

begin

if (rst_int_reg && !pkt_valid )

internal_parity <= 8'b0;

end

end

always @(posedge clk)

begin

if(!rst)

packet_parity_byte <= 8'b0;

else

begin

if(!parity_done && ld_state)

packet_parity_byte <=din;

if(rst_int_reg && !pkt_valid)

packet_parity_byte <= 8'b0;

end

end

always @(posedge clk)

begin

if(!rst)

err <= 1'b0;

else

begin

if(parity_done)

begin

if(internal_parity !=packet_parity_byte)

err <= 1'b1;

else

err <= 1'b0;

end

end

end

endmodule