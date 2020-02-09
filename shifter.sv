module shifter (output logic[31:0] out , input logic[31:0] in , logic[4:0] shamt , logic[1:0] sh_ops);

logic[31:0] sh_lt , sh_rt  , ash_temp , ash_rt_one , ash_rt ;

assign sh_lt = in << shamt ;
assign sh_rt = in >> shamt ;

assign ash_temp= 32'hffffffff << (5'h1f - shamt) ;
assign ash_rt_one = ash_temp | sh_rt ;
assign ash_rt = in[31] ? ash_rt_one : sh_rt ;

always_comb
begin

unique case (sh_ops) 

2'h3 : out = sh_lt ;
2'h1 : out = sh_rt ;
2'h2 : out = ash_rt ;
default: out = 0 ;
endcase

end



endmodule 




module tb_shifter() ;

logic[31:0] out , in ;
logic[4:0] shamt ;
logic[5:0] sh_ops ;

shifter s1 (.*);

initial
begin
#0 shamt = 4 ; in = 5 ; sh_ops = 3 ;
#10 shamt = 4 ; in = 5 ; sh_ops = 1 ;
#10 shamt = 4 ; in = 5 ; sh_ops = 2 ;

#10 shamt = 4 ; in = 32'hffff1111 ; sh_ops =3 ;
#10 shamt = 4 ; in = 32'hffff1111 ; sh_ops = 1 ;
#10 shamt = 4 ; in = 32'hffff1111 ; sh_ops = 2 ;

#10 shamt = 31 ; in = 32'hffff1111 ; sh_ops = 3 ;
#10 shamt = 31 ; in = 32'hffff1111 ; sh_ops = 1 ;
#10 shamt = 31 ; in = 32'hffff1111 ; sh_ops = 2 ;

end

endmodule


