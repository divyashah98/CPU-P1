`define r_type  7'h33 
`define i_type0 7'h3 
`define i_type1 7'h13 
`define i_type2  7'h67 
`define s_type 7'h23 
`define b_type  7'h63 
`define j_type  7'h6f 

`define lui  7'h37     // u type
`define auipc  7'h17 



`define add  4'h0      // r type   {func7[5],func3}
`define and 4'h7 
`define or 4'h6 
`define sll  4'h1 
`define slt 4'h2 
`define sltu  4'h3 
`define sra 4'b1101
`define srl  4'h5 
`define sub 4'h8 
`define xor 4'h4 



`define lb  3'h0            // i_type 0  {func3}
`define lbu  3'h4 
`define lh  3'h1 
`define lhu  3'h5 
`define lw 3'h2 

`define addi  3'h0 
`define andi  3'h7       // i_type 1 {func3}
`define ori 3'h6 
`define slli 3'h1 
`define srli  3'h5 
`define slti  3'h2 
`define sltiu  3'h3 
`define srai 3'h5 
`define xori  3'h4 

`define jalr 7'h67      //i_ type2 {opcode}



`define sb  3'h0        // s_type {func3}
`define sh  3'h1 
`define sw  3'h2 


`define beq 3'h0          // b type {func3}
`define bne  3'h1 
`define blt 3'h4 
`define bge 3'h5 
`define bltu  3'h6 
`define bgeu  3'h7 

`define jal  7'b1101111  // j type {opcode}

