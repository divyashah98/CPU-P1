  `include "instructions_def.sv"
`include "alu_control.sv"


module controller (input logic[31:0] instr ,
                   output logic[31:0] sign_ex_20 , u_type_imm , j_type_imm , b_type_imm , logic[6:0] alu_ops , 
                   logic[4:0] rs1_sel , rs2_sel , rd_sel , logic reg_wr_en , dmem_wr_en, 
                   logic[2:0] msel_op2 , msel_op1 , msel_reg_wr ,  logic[1:0] wr_byte_sel, pc_sel ,
                   logic flush , br_en , op2_def , op1_def );


logic[11:0] imm_12 ;
logic[6:0] opcode , func7 ;
logic[4:0] msel_op1_temp , msel_op2_temp ;
logic[3:0] r_type_opc ;
logic[2:0] func3 ;
logic en_r_type , en_i_type0 , en_i_type1 , en_i_type2 , en_s_type , en_b_type  , en_j_type , en_u_type ;
logic i_type_imm , s_type_imm ;


assign opcode = instr[6:0] ;
assign func3 = instr[14:12] ;
assign func7 = instr[31:25] ;
assign r_type_opc = { func7[5] , func3 };
assign rs2_sel = instr[24:20] ;
assign rs1_sel = instr[19:15] ;
assign rd_sel = instr[11:7] ;
assign op1_def = ( ( en_u_type == 0 ) && (en_j_type == 0) ) ? 1 : 0 ;
assign op2_def = ( ( en_u_type == 1 ) || (en_j_type == 1) || (en_i_type0 == 1) || (en_i_type1 == 1) || (en_i_type2 == 1) || (en_s_type == 1)) ;

//assign imm_12 = ( i_type_imm == 1'b1 ) ? ( instr[31:20] ) : ( s_type_imm == 1'b1 ) ? ( { instr[31:25] , instr[11:7] } ) : 0 ;
assign sign_ex_20 = { {20{imm_12[11]}} ,  imm_12[11:0] } ;
assign u_type_imm = { instr[31:12] , 12'b0 } ;
assign j_type_imm = { { 11{ instr[31] } } , instr[31] , instr[19:12] , instr[20] , instr[30:21] , 1'b0 } ;
assign b_type_imm = { { 19{ instr[31] } } , instr[31] , instr[7] , instr[30:25] , instr[11:8] , 1'b0 } ;


always_comb
begin
if(i_type_imm == 1)
imm_12 = instr[31:20] ;
else if(s_type_imm == 1)
imm_12 = { instr[31:25] , instr[11:7] } ;
end





always_comb
begin

en_r_type = 0 ;
en_i_type0 = 0 ;
en_i_type1 = 0 ;
en_i_type2 = 0 ;
en_s_type = 0 ;
en_b_type = 0 ;
en_j_type = 0 ;
en_u_type = 0 ;                 
               
case (opcode)

`r_type       : en_r_type = 1 ;
`i_type0      : en_i_type0 = 1 ;
`i_type1      : en_i_type1 = 1 ;
`i_type2      : en_i_type2 = 1 ;
`s_type       : en_s_type = 1 ;
`b_type       : en_b_type = 1 ;
`j_type       : en_j_type = 1 ;
`lui , `auipc : en_u_type = 1 ;

default       : begin 
                en_r_type = 0 ;
                en_i_type0 = 0 ;
                en_i_type1 = 0 ;
                en_i_type2 = 0 ;
                en_s_type = 0 ;
                en_b_type = 0 ;
                en_j_type = 0 ;
                en_u_type = 0 ; 
                end
endcase
end

always_comb
begin

if(en_r_type == 1)
begin

reg_wr_en = 1;
dmem_wr_en = 0;
msel_op1 = 0 ;
msel_op2 = 0 ;
msel_reg_wr = 0 ;
i_type_imm = 0 ;
s_type_imm = 0 ;
flush = 0 ;
pc_sel = 0 ;
br_en = 0 ;

case (r_type_opc)

`add   : alu_ops = `add_op ;
`and   : alu_ops = `and_op ;
`or    : alu_ops = `or_op ;
`sll   : alu_ops = `shl_op ;
`slt   : alu_ops = `blt_op ;
`sltu  : alu_ops = `bltu_op ;
`sra   : alu_ops = `sra_op ;
`srl   : alu_ops = `shr_op ;
`sub   : alu_ops = `sub_op ;
`xor   : alu_ops = `xor_op ;

endcase
end

else if (en_i_type0 == 1'b1)
begin
reg_wr_en = 1;
dmem_wr_en = 0;
msel_op1 = 0 ;
msel_op2 = 1 ;
alu_ops = `add_op ;
i_type_imm = 1 ;
s_type_imm = 0 ;
flush = 0 ;
pc_sel = 0 ;
br_en = 0 ;

case (func3)

`lw  : msel_reg_wr = 3'b001 ;
`lh  : msel_reg_wr = 3'b010 ;
`lhu : msel_reg_wr = 3'b011 ;
`lb  : msel_reg_wr = 3'b100 ;
`lbu : msel_reg_wr = 3'b101 ;

endcase
end

else if( en_i_type1 == 1'b1 )
begin

reg_wr_en = 1;
dmem_wr_en = 0;
msel_op1 = 0 ;
msel_op2 = 1 ;
msel_reg_wr = 0 ;
i_type_imm = 1 ;
s_type_imm = 0 ;
flush = 0 ;
pc_sel = 0 ;
br_en = 0 ;

case (func3)

`addi   : alu_ops = `add_op ;
`andi   : alu_ops = `and_op ;
`ori    : alu_ops = `or_op ;
`slli   : alu_ops = `shl_op ;
`slti   : alu_ops = `blt_op ;
`sltiu  : alu_ops = `bltu_op ;
`srai , `srli: begin 
               if (func7[5]==1'b1)
               begin 
               alu_ops = `sra_op ;
               end 
               else
               begin
               alu_ops = `shr_op ;
               end 
               end 
`xori   : alu_ops = `xor_op ;

endcase
end




else if ( en_i_type2 == 1'b1 )                                                        // jalr
begin
reg_wr_en = 1;
dmem_wr_en = 0;
msel_op1 = 0 ;
msel_op2 = 1 ;
msel_reg_wr = 7 ;
i_type_imm = 1 ;
s_type_imm = 0 ;
alu_ops =`add_op ;
flush = 1 ;
pc_sel = 1 ;
br_en = 0 ;
end


else if ( en_s_type == 1'b1 )
begin

reg_wr_en = 0 ;
dmem_wr_en = 1 ;
msel_op1 = 0 ;
msel_op2 = 1 ;
msel_reg_wr = 0 ;
s_type_imm = 1 ;
i_type_imm = 0;
alu_ops = `add_op ;
flush = 0 ;
pc_sel = 0 ;
br_en = 0 ;

case (func3)

`sb : wr_byte_sel = 2'b00 ;
`sh : wr_byte_sel = 2'b01 ;
`sw : wr_byte_sel = 2'b10 ;

endcase
end



else if ( en_b_type == 1 )
begin
reg_wr_en = 0;
dmem_wr_en = 0;
msel_op1 = 0 ;
msel_op2 = 0 ;
msel_reg_wr = 0 ;
i_type_imm = 0 ;
s_type_imm = 0 ;
flush = 0 ;
pc_sel = 0 ;
br_en = 1 ;

case (func3)

`beq  : alu_ops = `beq_op ;
`bne  : alu_ops = `bne_op ;
`blt  : alu_ops = `blt_op ;
`bltu : alu_ops = `bltu_op ;
`bge  : alu_ops = `bge_op  ;
`bgeu : alu_ops = `bgeu_op ;

endcase

end

else if ( en_u_type == 1'b1 )
begin

reg_wr_en = 1;
dmem_wr_en = 0;
msel_op1 = 1 ;
msel_op2 = 2 ;
i_type_imm = 0 ;
s_type_imm = 0 ;
alu_ops = `add_op ;
flush = 0 ;
pc_sel = 0 ;
br_en = 0 ;

case(opcode)

`lui : begin 
       msel_reg_wr = 0 ;
       msel_op1 = 6 ;
       msel_op2 = 2 ;
       end


`auipc : begin
         msel_reg_wr = 0 ;
         msel_op1 = 1 ;
         msel_op2 = 2 ; 
         end

endcase
end


else if ( en_j_type == 1'b1 )                           // jal
begin
reg_wr_en = 1;
dmem_wr_en = 0;
msel_op1 = 1 ;
msel_op2 = 3 ;
msel_reg_wr = 7 ;
i_type_imm = 0 ;
s_type_imm = 0 ;
alu_ops =`add_op ;
flush = 1 ;
pc_sel = 1 ;
br_en = 0 ;
end



else 
begin
alu_ops = `and_op ;
reg_wr_en = 0 ;
dmem_wr_en = 0 ;
msel_op2 = 0 ;
pc_sel = 0 ;
br_en = 0 ;
end
end




endmodule






                