module cmp (output logic result , input logic[31:0] op1 , op2 , logic[1:0] operation) ;

always_comb 
begin

case(operation)

2'b11 : result = op1 == op2 ;
2'b01 : result = op1 > op2 ;
2'b10 : result = op1 < op2 ;

endcase

end

endmodule





module tb_cmp() ;

logic result ;
logic[31:0] op1 , op2 ;
logic[2:0] operation ;


cmp c1 (.*) ;

initial
begin

op1 = 100 ; op2 = 250 ; operation = 3 ;
#10 op1 = 100 ; op2 = 250 ; operation = 1 ;
#10 op1 = 100 ; op2 = 250 ; operation = 2 ;
#10 op1 = 100 ; op2 = 50 ; operation = 3 ;
#10 op1 = 100 ; op2 = 50 ; operation = 1 ;
#10 op1 = 100 ; op2 = 50 ; operation = 2 ;
#10 op1 = 10 ; op2 = 10 ; operation = 3 ;
#10 op1 = 10 ; op2 = 10 ; operation = 1 ;
#10 op1 = 10 ; op2 = 10 ; operation = 2 ;

end

endmodule
