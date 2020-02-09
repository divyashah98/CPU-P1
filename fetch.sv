module fetch (output logic[31:0] pc , input logic[31:0] pc_jalr ,pc_br_addr , logic[1:0] pc_sel , logic clk , rst , br_en ) ;

logic[31:0] pc_sel_out ;

always_comb
begin
pc_sel_out = pc+4 ;
case( { br_en , pc_sel } )

3'b000 : pc_sel_out = pc + 4 ;
3'b001 : pc_sel_out = pc_jalr ; 
3'b100 : pc_sel_out = pc_br_addr ;

endcase
end


always_ff @ (posedge clk)
begin
if (rst == 1'b1)
begin
pc <= 32'h000 ;
end
else
pc<= pc_sel_out ;
end

endmodule

 
module tb_fetch();

logic[31:0] pc ;
logic clk , rst ;

fetch f1 (.*) ;

initial
begin

clk = 0 ;
#2 rst = 1;
#10 rst = 0;

end

always
begin
#10 clk = ~clk ;
end


endmodule 







