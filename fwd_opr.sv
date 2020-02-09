module fwd_opr (input logic[4:0] rs1_sel , rs2_sel , rd_sel_ex_mem , rd_sel_mem_wb , logic[2:0] reg_wr_mux_sel_ex_mem , 
                reg_wr_mux_sel_mem_wb , op1_msel_temp , op2_msel_temp , logic reg_wr_en_ex_mem , reg_wr_en_mem_wb , 
                logic op1_def , op2_def , dmem_wr_en_id_ex ,  output logic[2:0] op1_sel , op2_sel , logic[2:0] dmem_wr_in_sel ) ;
          

assign alu_wr_reg_ex_mem = ( reg_wr_mux_sel_ex_mem == 0 ) ;
assign alu_wr_reg_mem_wb = ( reg_wr_mux_sel_mem_wb == 0 ) ;

assign ld_wr_reg_ex_mem =  ( reg_wr_mux_sel_ex_mem == 1 ) || ( reg_wr_mux_sel_ex_mem == 2 ) || ( reg_wr_mux_sel_ex_mem == 3 )
                           || ( reg_wr_mux_sel_ex_mem == 4 ) || ( reg_wr_mux_sel_ex_mem == 5 ) ;

assign ld_wr_reg_mem_wb =  ( reg_wr_mux_sel_mem_wb == 1 ) || ( reg_wr_mux_sel_mem_wb == 2 ) || ( reg_wr_mux_sel_mem_wb == 3 )
                           || ( reg_wr_mux_sel_mem_wb == 4 ) || ( reg_wr_mux_sel_mem_wb == 5 ) ;


always_comb
begin

if(op1_def == 0)
begin
op1_sel =  op1_msel_temp ;
end

else if (reg_wr_en_ex_mem == 1 && alu_wr_reg_ex_mem == 1 && rd_sel_ex_mem == rs1_sel )
begin
op1_sel =  2 ;
end


else if (reg_wr_en_ex_mem == 1 && ld_wr_reg_ex_mem == 1 && rd_sel_ex_mem == rs1_sel )
begin
op1_sel =  4 ;
end



else if (reg_wr_en_mem_wb == 1 && alu_wr_reg_mem_wb == 1 && rd_sel_mem_wb == rs1_sel )
begin
op1_sel =  3 ;
end



else if (reg_wr_en_mem_wb == 1 && ld_wr_reg_mem_wb == 1 && rd_sel_mem_wb == rs1_sel )
begin
op1_sel =  5 ;
end

else
begin
op1_sel =  op1_msel_temp ;
end

end





always_comb
begin

if(op2_def == 1)
begin
op2_sel =  op2_msel_temp ;
end

else if (reg_wr_en_ex_mem == 1 && alu_wr_reg_ex_mem == 1 && rd_sel_ex_mem == rs2_sel )
begin
op2_sel =  4 ;
end

else if (reg_wr_en_ex_mem == 1 && ld_wr_reg_ex_mem == 1 && rd_sel_ex_mem == rs2_sel )
begin
op2_sel =  6 ;
end


else if (reg_wr_en_mem_wb == 1 && alu_wr_reg_mem_wb == 1 && rd_sel_mem_wb == rs2_sel )
begin
op2_sel =  5 ;
end



else if (reg_wr_en_mem_wb == 1 && ld_wr_reg_mem_wb == 1 && rd_sel_mem_wb == rs2_sel )
begin
op2_sel =  7 ;
end

else
begin
op2_sel =  op2_msel_temp ;
end

end






always_comb
begin

if( dmem_wr_en_id_ex == 1 && reg_wr_en_ex_mem == 1 && ld_wr_reg_ex_mem == 1 && rd_sel_ex_mem == rs2_sel )
begin
dmem_wr_in_sel = 1 ;
end


else if ( dmem_wr_en_id_ex == 1 && reg_wr_en_ex_mem == 1 && alu_wr_reg_ex_mem == 1 && rd_sel_ex_mem == rs2_sel )
begin
dmem_wr_in_sel = 3 ;
end


else if( dmem_wr_en_id_ex == 1 && reg_wr_en_mem_wb == 1 && ld_wr_reg_mem_wb == 1 && rd_sel_mem_wb == rs2_sel)
begin
dmem_wr_in_sel = 2 ;
end

else if ( dmem_wr_en_id_ex == 1 && reg_wr_en_mem_wb == 1 && alu_wr_reg_mem_wb == 1 && rd_sel_mem_wb == rs2_sel )
begin
dmem_wr_in_sel = 4 ;
end

else
begin
dmem_wr_in_sel = 0 ;
end

end

endmodule
