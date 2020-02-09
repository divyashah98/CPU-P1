module regfile (output logic[31:0] rs1 , rs2 ,input logic[31:0] wr_data , logic[4:0] rd_p1_addr , rd_p2_addr , wr_addr , logic clk , wr_en );

logic[31:0] regbank [31:0] ;
logic[31:0] regbank_temp[31:1] ;

assign regbank[0]= 0;
assign regbank[31:1] = regbank_temp[31:1] ;
assign rs1 = regbank[rd_p1_addr] ;
assign rs2 = regbank[rd_p2_addr] ;


always_ff @ (negedge clk)                                                   // writes at negedge , pipe regs at posedge
begin
if (wr_en == 1'b1)
begin
regbank_temp[wr_addr] <= wr_data ;
end
end

endmodule



module tb_regfile ;

logic[31:0] rs1 , rs2 ;
logic[31:0] wr_data ;
logic[4:0] rd_p1_addr , rd_p2_addr , wr_addr ;
logic clk , wr_en ;

regfile r1 (.*) ;

initial
begin
clk=0;
#8 wr_en = 1 ; wr_addr=1 ; wr_data=12;
#20 wr_addr = 2 ; wr_data=45;
#3 rd_p1_addr=0; rd_p2_addr=1;
#3 rd_p1_addr=2;
end




always
begin
#10 clk = ~clk ;
end

endmodule
