module top (input logic clk , rst ) ;


logic[31:0]  instr_out_i , instr_out_o , rs1_out_i , rs1_out_o , rs2_out_i , rs2_out_o ;
logic[31:0] alu_out_i1, alu_out_o1 , alu_out_o2 , alu_out , sign_ex_20_i , sign_ex_20_o , alu_op1 , alu_op2 ;
logic[31:0] dmem_data_out_i , dmem_data_out_o , dmem_data_in , reg_wr_data_in ;
logic[31:0] lw_in , lh_in , lhu_in , lb_in , lbu_in ;
logic[31:0] u_type_imm_i , u_type_imm_o1 , u_type_imm_o2 , u_type_imm_o3 ; 
logic[31:0] pc_out , pc_out_o1 , pc_out_o2 , pc_j0 , pc_j1 ;
logic[31:0] j_type_imm_i , j_type_imm_o ;
logic[31:0] b_type_imm_i , b_type_imm_o ;
logic[31:0] pc_br_addr ;
logic[6:0] alu_ops_i , alu_ops_o ;
logic[4:0] rd_sel_i1 , rd_sel_o1 , rd_sel_o2 , rd_sel_o3 , rs1_sel , rs2_sel ;
logic[1:0] dmem_byte_sel_i , dmem_byte_sel_o1 , dmem_byte_sel_o2 ;
logic reg_wr_en_i1 , reg_wr_en_o1 , dmem_wr_en_i1 , dmem_wr_en_o1 , reg_wr_en_o2 , dmem_wr_en_o2 , reg_wr_en_o3 ;
logic flush_i , flush_o1 , flush_o2 ;
logic[2:0] mux_op2_sel_i , mux_op2_sel_o , reg_wr_mux_sel_i , reg_wr_mux_sel_o1 , reg_wr_mux_sel_o2 , reg_wr_mux_sel_o3 ;
logic[2:0] mux_op1_sel_i , mux_op1_sel_o ;
logic[1:0] pc_sel_i , pc_sel_o ;
logic br_en_i , br_en_o , br_en_res , br_en_res_o ;
logic pc_co ;
logic[4:0] rs1_sel_o , rs2_sel_o ;
logic op1_def_i , op1_def_o , op2_def_i , op2_def_o ;
logic[2:0] mux_op1_sel , mux_op2_sel ;
logic[2:0] dmem_wr_in_sel , dmem_wr_in_sel_o ;
logic[31:0] dmem_wr_in_mux_out , dmem_data_out_o2 , alu_out_o3 ;


assign lw_in  = dmem_data_out_o ;
assign lh_in  = { {16{dmem_data_out_o[15]}} , dmem_data_out_o[15:0] } ;
assign lhu_in = { 16'b0 , dmem_data_out_o[15:0] } ;
assign lb_in  = { {24{dmem_data_out_o[7]}} , dmem_data_out_o[7:0] } ;
assign lbu_in = { 24'b0 , dmem_data_out_o[7:0] } ; 
assign br_en_res = br_en_o & alu_out_i1[0] ;



always_comb
begin
dmem_wr_in_mux_out = dmem_data_in ;
case(dmem_wr_in_sel_o)

3'b000 : dmem_wr_in_mux_out = dmem_data_in ;                // rs2 out
3'b001 : dmem_wr_in_mux_out = dmem_data_out_o ;
3'b010 : dmem_wr_in_mux_out = dmem_data_out_o2 ;
3'b011 : dmem_wr_in_mux_out = alu_out_o2 ;
3'b100 : dmem_wr_in_mux_out = alu_out_o3 ;

endcase
end




fetch f1        ( .pc(pc_out) ,.pc_sel(pc_sel_o) , .pc_jalr(alu_out_i1) , .br_en(br_en_res) , .pc_br_addr(pc_br_addr) ,.* ) ;

imem im1        (  .instr_out (instr_out_i) ,  .in_addr (pc_out) );

controller cl1  ( .instr(instr_out_o) ,  .alu_ops(alu_ops_i) ,  .rs1_sel(rs1_sel) , .rs2_sel(rs2_sel) , 
                  .rd_sel(rd_sel_i1) ,  .reg_wr_en(reg_wr_en_i1) , .dmem_wr_en ( dmem_wr_en_i1 ) , 
                  .sign_ex_20(sign_ex_20_i) , .msel_op2(mux_op2_sel_i) , .msel_reg_wr(reg_wr_mux_sel_i) ,
                  .wr_byte_sel(dmem_byte_sel_i) , .u_type_imm(u_type_imm_i) , .msel_op1(mux_op1_sel_i) ,
                  .flush(flush_i) , .pc_sel(pc_sel_i) , .j_type_imm(j_type_imm_i) , .br_en(br_en_i) ,
                  .b_type_imm(b_type_imm_i) , .op1_def(op1_def_i) , .op2_def(op2_def_i) ) ;





fwd_opr   fu   ( .rs1_sel(rs1_sel_o) , .rs2_sel(rs2_sel_o) , .rd_sel_ex_mem(rd_sel_o2) , .rd_sel_mem_wb(rd_sel_o3) , 
                 .reg_wr_mux_sel_ex_mem(reg_wr_mux_sel_o2) , .reg_wr_mux_sel_mem_wb(reg_wr_mux_sel_o3) , 
                 .op1_msel_temp(mux_op1_sel_o) , .op2_msel_temp(mux_op2_sel_o) , .reg_wr_en_ex_mem(reg_wr_en_o2) , 
                 .reg_wr_en_mem_wb(reg_wr_en_o3) , .op1_def(op1_def_o) , .op2_def(op2_def_o) , 
                 .dmem_wr_en_id_ex(dmem_wr_en_o1) ,  .op1_sel(mux_op1_sel) , .op2_sel(mux_op2_sel) , 
                 .dmem_wr_in_sel(dmem_wr_in_sel) ) ;
                 



regfile rr1     ( .rs1(rs1_out_i) , .rs2(rs2_out_i) , .wr_data(reg_wr_data_in) , .rd_p1_addr (rs1_sel) , .rd_p2_addr(rs2_sel) , 
                  .wr_addr(rd_sel_o3) ,  .clk(clk) , .wr_en(reg_wr_en_o3) ) ;


mux op1_msel    (.a(rs1_out_o) , .b(pc_out_o2) , .c(alu_out_o1) , .d(alu_out_o2) , .e(dmem_data_out_i) , .f(dmem_data_out_o) ,
                 .g(32'b0) , .mux_sel(mux_op1_sel) , .mux_out(alu_op1) ) ;


mux op2_msel    (.a(rs2_out_o) , .b(sign_ex_20_o) , .c(u_type_imm_o1) , .d(j_type_imm_o) , .e(alu_out_o1) , .f(alu_out_o2) , 
                 .g(dmem_data_out_i) , .h(dmem_data_out_o) , .mux_sel(mux_op2_sel) , .mux_out(alu_op2) ) ;

alu al1         (.out(alu_out_i1) ,  .b(alu_op2) , .a(alu_op1) ,  .alu_ops(alu_ops_o)) ;


dmem dm1        ( .rd_data(dmem_data_out_i) ,  .wr_data(dmem_wr_in_mux_out) , .data_addr(alu_out_o1) , 
                  .wr_byte_sel(dmem_byte_sel_o2) , .wr_en(dmem_wr_en_o2) , .clk(clk)     ) ;

mux reg_wr_sel  ( .mux_sel(reg_wr_mux_sel_o3) , .mux_out(reg_wr_data_in) , .a(alu_out_o2) , .b(lw_in) , .c(lh_in) , .d(lhu_in) ,
                  .e(lb_in) , .f(lbu_in) , .g(u_type_imm_o3) , .h(pc_j1) ) ;

cla ca1         ( .s(pc_br_addr) ,  .c_out(pc_co) , .a(b_type_imm_o) , .b(pc_out_o2) , .c_in(1'b0) );



always_ff @ (posedge clk)
begin

//instr_out_o <= instr_out_i ;            // if-id stage
pc_out_o1 <= pc_out ;



alu_ops_o <=  alu_ops_i ;               // id-ex stage
rd_sel_o1 <= rd_sel_i1 ;
//reg_wr_en_o1 <= reg_wr_en_i1 ;
//dmem_wr_en_o1 <=  dmem_wr_en_i1 ;
rs2_out_o <= rs2_out_i ;
rs1_out_o <= rs1_out_i ;
sign_ex_20_o <= sign_ex_20_i ;
mux_op2_sel_o <= mux_op2_sel_i ;
mux_op1_sel_o <= mux_op1_sel_i ; 
reg_wr_mux_sel_o1 <= reg_wr_mux_sel_i ;
dmem_byte_sel_o1 <= dmem_byte_sel_i ;
u_type_imm_o1 <= u_type_imm_i ; 
pc_out_o2 <= pc_out_o1 ;
flush_o1 <= flush_i ;
pc_sel_o <= pc_sel_i ;
j_type_imm_o <= j_type_imm_i ;
//br_en_o <= br_en_i ;
b_type_imm_o <= b_type_imm_i ;
rs1_sel_o <= rs1_sel ;
rs2_sel_o <= rs2_sel ;
op1_def_o <= op1_def_i ;
op2_def_o <= op2_def_i ;



alu_out_o1 <= alu_out_i1 ;                // ex-mem stage
//reg_wr_en_o2 <= reg_wr_en_o1 ;
//dmem_wr_en_o2 <=  dmem_wr_en_o1 ;
rd_sel_o2 <= rd_sel_o1 ;
reg_wr_mux_sel_o2 <= reg_wr_mux_sel_o1 ;
dmem_byte_sel_o2 <= dmem_byte_sel_o1 ;
dmem_data_in <= rs2_out_o ;
u_type_imm_o2 <= u_type_imm_o1 ;
//flush_o2 <= flush_o1 ;
pc_j0 <= pc_out_o1 ;
//br_en_res_o <= br_en_res ;
dmem_wr_in_sel_o <= dmem_wr_in_sel ;
dmem_data_out_o2 <= dmem_data_out_o ;             // dmem out reversed by delaying
alu_out_o3 <= alu_out_o2 ;                        // alu out reversed by delaying    
 


//reg_wr_en_o3 <= reg_wr_en_o2 ;           // mem-wb stage
alu_out_o2 <= alu_out_o1 ;
rd_sel_o3 <= rd_sel_o2 ;
dmem_data_out_o <= dmem_data_out_i ;
reg_wr_mux_sel_o3 <= reg_wr_mux_sel_o2 ;
u_type_imm_o3 <= u_type_imm_o2 ;  
pc_j1 <= pc_j0 ;


if (rst == 1'b1)
begin
instr_out_o <= 0 ;
reg_wr_en_o1 <= 0 ;
reg_wr_en_o2 <= 0 ;
reg_wr_en_o3 <= 0 ;
dmem_wr_en_o2 <= 0 ;
dmem_wr_en_o1 <= 0 ;
flush_o2 <= 0 ;
br_en_o  <= 0 ;
br_en_res_o <= 0 ;
end


else if(flush_o2 == 1'b1 || br_en_res_o == 1  )
begin

reg_wr_en_o1   <=  0 ;
dmem_wr_en_o1  <=  0 ;
reg_wr_en_o2   <=  0 ;
dmem_wr_en_o2  <=  0 ;

instr_out_o <= instr_out_i ;
br_en_o <= br_en_i ;
flush_o2 <= flush_o1 ;
br_en_res_o <= br_en_res ;
reg_wr_en_o3 <= reg_wr_en_o2 ;

end

else
begin
instr_out_o <= instr_out_i ;

reg_wr_en_o1 <= reg_wr_en_i1 ;
dmem_wr_en_o1 <=  dmem_wr_en_i1 ;
br_en_o <= br_en_i ;

reg_wr_en_o2 <= reg_wr_en_o1 ;
dmem_wr_en_o2 <=  dmem_wr_en_o1 ;
flush_o2 <= flush_o1 ;
br_en_res_o <= br_en_res ;

reg_wr_en_o3 <= reg_wr_en_o2 ;
end

end
endmodule



