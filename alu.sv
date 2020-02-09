`include "alu_control.sv"

module alu (output logic[31:0] out , input logic[31:0] b , a , logic[6:0] alu_ops) ;

logic[31:0] add_out , logic_out , shift_out , op_b ;
logic cin , cout , cmp_out ;
logic[1:0] cmp_ops , logic_ops , sh_ops ;

assign cin = alu_ops[0];
assign op_b = alu_ops[0] ? (~b) : b;
assign logic_ops = alu_ops[2:1] ;
assign sh_ops = alu_ops[4:3] ;
assign cmp_ops = alu_ops[6:5] ;

cla  c1 (.a(a) , .b(op_b) , .c_in(cin) , .s ( add_out) , .c_out(cout) ); 
logical   l1 (.op1(a) , .op2(b) , .ops(logic_ops) , .out(logic_out) );
shifter   s1 ( .in(a) , .shamt( b[4:0] ) , .out(shift_out) , .sh_ops (sh_ops) );



always_comb
begin

 case (alu_ops)

`add_op , `sub_op          :  out = add_out ;
`and_op , `or_op , `xor_op :  out = logic_out ;
`shl_op , `shr_op ,`sra_op :  out = shift_out ;
`beq_op                    :  out = ( a == b );
`bne_op                    :  out = ( a != b );
`blt_op                    :  out = ( a < b ) ;
`bge_op                    :  out = ( a >= b ) ;
`bltu_op                   :  out = ( $signed(a) < $signed(b)  ) ;
`bgeu_op                   :  out = ( $signed(a) >= $signed(b) ) ; 

default : out = 0;

endcase

end

endmodule



module tb_alu();

logic[31:0] out , a , b ;
logic[6:0] alu_ops ;



alu a1 (.*) ;


initial
begin

#0 a = 50 ; b = 32'hffffffff ; alu_ops=`bgeu_op ;




/*for (int i = 1 ; i<= 10 ; i++)
begin
#10 alu_ops = arr[i] ;
end */

end

endmodule 
