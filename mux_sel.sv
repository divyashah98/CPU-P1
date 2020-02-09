module mux (output logic[31:0] mux_out , input logic[31:0] a , b , c , d , e , f , g , h , logic[2:0] mux_sel);

always_comb
begin

case(mux_sel)

0 : mux_out = a ;
1 : mux_out = b ;
2 : mux_out = c ;
3 : mux_out = d ;
4 : mux_out = e ;
5 : mux_out = f ;
6 : mux_out = g ;
7 : mux_out = h ;


endcase

end


endmodule
