module imem ( output logic[31:0] instr_out , input logic[31:0] in_addr );


parameter addr_begin = 32'h000 ;

logic[31:0] mem [2047:0] ;
logic[31:0] calc_addr ;

assign calc_addr = ( ( in_addr - addr_begin ) & 32'hfffc ) >> 2 ;

assign instr_out = mem [calc_addr] ;


endmodule


module tb_imem ;

logic[31:0] in , out ;

imem i1 ( .in_addr (in) , .instr_out (out) );

initial 
begin
$readmemh ("test.hex" , i1.mem );
$display ("mem = %x",i1.mem[0]) ; 

#10 in = 32'h2000 ;
#10 in=in+4;
#10 in=in+4;


end

endmodule

