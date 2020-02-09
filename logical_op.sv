module logical (output logic[31:0] out , input logic[31:0] op1 , op2 , logic[1:0] ops) ;

always_comb
begin

unique case (ops)

2'b11 : out = op1 & op2 ;
2'b01 : out = op1 | op2 ;
2'b10 : out = op1 ^ op2 ;
default: out = 0 ;
endcase

end


endmodule


module tb_logical();

logic[31:0] out , op1 , op2 ;
logic[2:0] ops ;

logical l1 (.*);

initial
begin

op1 = 7 ; op2 = 6 ; ops = 3;
#10 op1 = 7 ; op2 = 6 ; ops = 1;
#10 op1 = 7 ; op2 = 6 ; ops = 2;


end

endmodule



