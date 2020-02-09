module dmem (output logic[31:0] rd_data , input logic[31:0] wr_data , data_addr , logic[1:0] wr_byte_sel ,  logic wr_en , clk) ;

parameter addr_begin = 32'h0 ;
logic[31:0] dmem [2047:0] ;
logic[31:0] wr_mask , calc_addr , req_adrr ;

assign calc_addr = ( ( data_addr - addr_begin ) & 32'hfffc ) >> 2 ;
assign rd_data = dmem[calc_addr] ;


//assign rd_data = {  dmem[data_addr+3] , dmem[data_addr+2] , dmem[data_addr+0] , dmem[data_addr] }   ;            // allow

always_comb
begin
if (wr_byte_sel == 2'b00 )
begin
wr_mask = 32'h000000ff ;
end

else if(wr_byte_sel == 2'b01)
begin
wr_mask = 32'h0000ffff ; 
end

else
begin
wr_mask = 32'hffffffff ;
end
end



always_ff @ (posedge clk)
begin
if(wr_en == 1'b1)
begin
dmem[calc_addr] <= (wr_data & wr_mask) | (~wr_mask & rd_data) ;


//{  dmem[data_addr+3] , dmem[data_addr+2] , dmem[data_addr+0] , dmem[data_addr] }  <= (wr_data & wr_mask) | (~wr_mask & rd_data) ;

end
end
 
endmodule



module tb_dmem () ;

logic[31:0] rd_data , wr_data , data_addr ;
logic[1:0] wr_byte_sel ;
logic wr_en , clk ;

dmem d1 (.*) ;

initial 
begin
clk = 0 ;
#5 wr_en = 1 ; data_addr = 0 ;wr_data = 32'hffffffff ; wr_byte_sel = 2 ;
#20 data_addr = 0 ; wr_data = 32'h1111 ; wr_byte_sel = 1 ;
#20 data_addr = 0 ; wr_data = 32'h00 ; wr_byte_sel = 0 ;
#20 data_addr = 4 ; wr_data = 32'h11 ; wr_byte_sel = 0 ;
#20 data_addr = 4 ; wr_data = 32'h2222 ; wr_byte_sel = 1 ;
#20 data_addr = 4 ; wr_data = 32'h44444444 ; wr_byte_sel = 2 ;

end

always
begin
#10 clk = ~ clk ;
end

endmodule

