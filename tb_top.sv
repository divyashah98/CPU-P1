module tb_top();

logic clk , rst ;

top tst (.*) ;


initial 
begin

$readmemh ("add.hex", tst.im1.mem ,0 ) ;
$readmemh ("reg_data.hex", tst.rr1.regbank , 1);
$readmemh ("reg_data.hex", tst.rr1.regbank_temp , 1);
$readmemh ("dmem_data.hex", tst.dm1.dmem ,0 ) ;

$monitor("%d pc_out = %x instr_i = %x instr_o = %x rtype = %x itype0 = %x itype1 = %x r_type_opc = %x alu_ops = %x mux_op2_sel_o = %x 
         op1_sel = %x op2_sel = %x imm_12 = %x op1 = %x op2 = %x imm_12 = %x alu_out = %x alu_out1 = %x  dmem_out = %x alu_out2 = %x 
         reg_wr_en = %x reg_in = %x reg_wr_sel_i = %x 
         reg_wr_sel_o3 = %x  rd_sel = %x  flush = %x br_en = %x br_en_res = %x  j_type_imm = %x pc_br_addr = %x pc_sel = %x 
         pc_sel_out = %x reg_wr = %x  dmem_wr_en = %x dmem_addr = %x dmem_wr_in_sel = %x , dmem_in = %x 
         dmem_data_out = %x dmem_data_out2 = %x alu_out_o2 = %x alu_out_o3 =%x \n", 
         

$time , tst.pc_out , tst.instr_out_i , tst.instr_out_o ,tst.cl1.en_r_type, tst.cl1.en_i_type0 ,tst.cl1.en_i_type1 , tst.cl1.r_type_opc , tst.alu_ops_o ,
tst.cl1.msel_op2 ,tst.mux_op1_sel ,tst.mux_op2_sel ,tst.cl1.imm_12 ,tst.al1.a , tst.al1.b ,tst.cl1.imm_12 ,tst.alu_out_i1 , tst.alu_out_o1 ,tst.dmem_data_out_o , tst.alu_out_o2 
,tst.reg_wr_en_o3, tst.reg_wr_data_in , tst.reg_wr_mux_sel_i , tst.reg_wr_mux_sel_o3 , tst.rd_sel_o3 , tst.flush_o2 ,tst.br_en_o , tst.br_en_res ,
         tst.j_type_imm_o,tst.pc_br_addr ,tst.pc_sel_o , tst.f1.pc_sel_out ,tst.reg_wr_en_o3 , tst.dmem_wr_en_o2 ,tst.alu_out_o1 , tst.dmem_wr_in_sel_o ,
        tst.dmem_wr_in_mux_out , tst.dmem_data_out_o , tst.dmem_data_out_o2 , tst.alu_out_o2 , tst.alu_out_o3);



clk = 0 ;
#2 rst = 1 ;
#10 rst = 0;




//$monitor("%d pc_out = %d instr_i = %d instr_o = %d alu_ops = %x alu out1 = %d alu out = %d rd sel = %d reg wr = %d ", 
        // $time , tst.pc_out , tst.instr_out_i , tst.instr_out_o , tst.alu_ops_o , tst.alu_out_o1 , tst.alu_out_o2 , tst.rd_sel_o3 , tst.reg_wr_en_o3);


//$display("%d instr = %d",$time  , tst.instr_out_i);
//#20 $display(" %d instr = %d",$time ,tst.instr_out_o); 
//#20 $display("%d alu_ops = %x",$time  , tst.alu_ops_o); 
//#20 $display("%d alu out = %d",$time , tst.alu_out_o1);
//#20 $display("%d alu out = %d",$time  ,tst.alu_out_o2);
//$display("%d rd sel = %d" , $time , tst.rd_sel_o3) ;
//$display("%d reg wr = %d" , $time  , tst.reg_wr_en_o3) ;



end

always
begin
#10 clk= ~clk ;
end

endmodule
