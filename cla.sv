
module cla (output logic[31:0] s,logic c_out,input logic[31:0] a,input logic[31:0] b , logic c_in);

parameter size = 32 ;
logic[size-1:0] c,g,p,t;


assign s[0] = a[0] ^ b[0] ^ c_in ;
assign c_out = c [size-1];
assign c[0] = ( a[0] & b[0] ) | ( c_in & b[0] ) | ( a[0] & c_in );

genvar i;
for( i=1 ; i<=size-1 ; i++)

begin

assign t[i] = a[i] ^ b[i];
assign s[i] = t[i] ^ c[i-1];
assign g[i] = a[i] & b[i];
assign p[i] = t[i] & (c[i-1]);
assign c[i] = g[i] | p[i];

end



endmodule


module tb_cla();

logic[31:0] s;
logic c_out;
logic[31:0] a, b ;
logic c_in ;

cla c1(.*);

initial
begin
#0 a = 50 ; b = 20 ; c_in =0 ;
end
endmodule


