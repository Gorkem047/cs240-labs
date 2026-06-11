// Code your design here

`define FETCH_STATE 0
`define DECODE_STATE 1
`define EXMEM_STATE 2
`define WB_STATE 3

module riscvcore
  (
    clk,
    rst, 
  	// RAM I/F
    memAddr,
    dataRd,
    dataWr,
    wrEn,
    mask
  );
  
  input clk, rst;
  // Memory I/F
  input [31:0] dataRd; // Data that we read from memory
  output reg [13:0] memAddr; // Address in the memory where we want to write to or read from
  output reg [31:0] dataWr; // Data that we want to write to memory
  output reg wrEn; // Enables writing to memory
  output reg [3:0] mask; // Masks the bits that we want to write to memory. e.g. For SB: mask = 4'b0001
  
  // Internal Signals
  reg [31:0] PC, PC_next;
  reg [1:0] state, state_next;  // FETCH = 0, DECODE = 1, EXMEM = 2, WB = 3 
  reg [31:0] instr, instr_next; // Current instruction
  
  // REGISTERS
  reg [31:0] regfile [0:31]; // Array that holds the registers. e.g. x1, x2, x3 ...
  reg [31:0] result, result_next; // Holds the value to write into regfile
  reg regfileWr, regfileWr_next;  // Regfile Write Signal
  
  // Decoder I/F
  wire [31:0] decoder_in;
  wire [6:0] opcode;
  wire [4:0] rd;
  wire [2:0] funct3,aluControl;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [6:0] funct7;
  wire [11:0] imm12;
  wire [19:0] imm20;
  wire regWrite, aluSrcA, aluSrcB, memWrite, branch, jump;
  wire [1:0] immSrc, resultSrc, aluOP;
  
  assign decoder_in = (state == `DECODE_STATE) ? dataRd:instr;
  
  riscv_decoder decoder(
    .clk(clk),
    .rst(rst),
    .in(decoder_in),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .imm12(imm12),
    .imm20(imm20),
    .aluControl(aluControl),
    .regWrite(regWrite),
    .aluSrcA(aluSrcA),
    .aluSrcB(aluSrcB),
    .memWrite(memWrite),
    .branch(branch),
    .jump(jump),
    .immSrc(immSrc),
    .resultSrc(resultSrc),
    .aluOP(aluOP)
  );
  
  always @(posedge clk) begin
    PC <= #1 PC_next;
    state <= #1 state_next;
    instr <= #1 instr_next;
    regfileWr <= #1 regfileWr_next;
    result <= #1 result_next;
    if (regfileWr)
      regfile[rd] <= #1 result;            
    //register değerlerini güncelleyebiliriz

  end
  
  always @(*) begin
    PC_next = PC;
    state_next = state + 1;
    instr_next = instr;
    regfileWr_next = 0;
    result_next = result;
    wrEn = 0;
    mask = 0;
    if (rst) begin
    	PC_next = 0;
      	state_next = 0;
     	regfileWr_next = 0;
    end else
      case(state)
        `FETCH_STATE: begin
    	 memAddr = PC;
        end
        `DECODE_STATE: begin
			instr_next = dataRd;
         	// Decode module will handle this state
        end
        `EXMEM_STATE: begin
          
          PC_next = PC + 4;
          if (opcode == 51) begin
            regfileWr_next = 1;
            

            if(funct3 == 0)begin
              
              if(funct7 == 0)begin
                
                result_next = regfile[rs1] + regfile[rs2];
              end
              
              if(funct7 == 32)begin
              
                result_next = regfile[rs1] - regfile[rs2];
              end
              
              if(funct7 == 1)begin
              
                result_next = regfile[rs1] * regfile[rs2];
              end
              
            end
            
            if(funct3 == 7)begin
              //and
              result_next = regfile[rs1] & regfile[rs2];
            end
            
            if(funct3 == 6)begin
              //or
              result_next = regfile[rs1] | regfile[rs2];
            end
            
            if(funct3 == 4)begin
              if(funct7 == 0)begin
              //xor
                result_next = regfile[rs1] ^ regfile[rs2];
              end
              
              if(funct7 == 1)begin
              //div
                result_next = regfile[rs1] / regfile[rs2];
              end
            end
            
            if(funct3 == 1)begin
              //sll
              result_next = regfile[rs1] << regfile[rs2];
            end
            
            if(funct3 == 5)begin
              if(funct7 == 0)begin
              //srl
                result_next = regfile[rs1] >> regfile[rs2];
              end
              
              if(funct7 == 32)begin
              
                result_next = regfile[rs1] >>> regfile[rs2];
              end
              
            end
            
            if(funct3 == 2)begin
              //slt
              if(regfile[rs1] < regfile[rs2])begin
                result_next = 1;
              end else begin
                result_next = 0;
              end
            end
            
            
          end
          
          if(opcode == 19)begin
            regfileWr_next = 1;
            
            if(funct3 == 0)begin
            //addi
              result_next = regfile[rs1] + {{20{imm12[11]}},imm12};
              
            end
            
            if(funct3 == 6)begin
            //ori
              result_next = regfile[rs1] | {{20{imm12[11]}},imm12};
            end
            
            if(funct3 == 4)begin
            //xori
              result_next = regfile[rs1] ^ {{20{imm12[11]}},imm12};
            end
            
            if(funct3 == 1)begin
            //slli
              result_next = regfile[rs1] << {{20{imm12[11]}},imm12};
            end
            
            if(funct3 == 5)begin
              if(funct7 == 0)begin
              //srli
                result_next = regfile[rs1] >> {{20{imm12[11]}},imm12};
              end
              
              if(funct7 == 32)begin
              //srai
                result_next = regfile[rs1] >>> rs2;
              end
            
            end
            
            if(funct3 == 2)begin
            //slti
              if(regfile[rs1] < {{20{imm12[11]}},imm12})begin
                result_next = 1;
              end else begin
                result_next = 0;
              end
            end
            
            if(funct3 == 7)begin
            //andi
              result_next = regfile[rs1] & {{20{imm12[11]}},imm12};
            end
            
          end
          
          if(opcode == 3)begin
            memAddr = regfile[rs1] + {{20{imm12[11]}},imm12};
         
  
            
          end
          
          if(opcode == 35)begin
            wrEn = 1;
            memAddr = regfile[rs1] + {{20{imm12[11]}},imm12};
            dataWr = regfile[rs2];
            if(funct3 == 0)begin
            //sb
              mask = 4'b0001;
            end
            
            if(funct3 == 1)begin
            //sh
              mask = 4'b0011;
            end
            
            if(funct3 == 2)begin
            //sw
              mask = 4'b1111;
            end
            
          end
          
          if(opcode == 99)begin
            
            if(funct3 == 0)begin
            //beq
              if(regfile[rs1] == regfile[rs2])begin
                PC_next = PC + {{20{imm12[11]}},imm12};
              end
            end
            
            if(funct3 == 1)begin
            //bne
              if(regfile[rs1] != regfile[rs2])begin
                PC_next = PC + {{20{imm12[11]}},imm12};
              end
            end
            
            if(funct3 == 4)begin
            //blt
              if(regfile[rs1] < regfile[rs2])begin
                PC_next = PC + {{20{imm12[11]}},imm12};
              end
            end
            
            if(funct3 == 5)begin
            //bge
              if(regfile[rs1] > regfile[rs2])begin
                PC_next = PC + {{20{imm12[11]}},imm12};
              end
            end
            
          end
          
          if(opcode == 111)begin
          //jal
            regfileWr_next = 1;
            result_next = PC + 4;
            PC_next = PC + {{12{imm20[19]}},imm20};
          end
          
          if(opcode == 55)begin
          //lui
            regfileWr_next = 1;
            result_next = {imm20,{12{1'b0}}};
          end
          
          if(opcode == 103)begin
          //jalr
            regfileWr_next = 1;
            result_next = PC + 4;
            PC_next = (regfile[rs1] + {{12{imm20[19]}},imm20}) & ~32'b1; 
            
          end
        
        end
        `WB_STATE: begin
          	
           if(opcode == 3)begin
            regfileWr_next = 1;
            
            if(funct3 == 2)begin
            //lw
              result_next = dataRd;
            end
            
            if(funct3 == 0)begin
            //lb
              result_next = dataRd & 255;
            end
            
            if(funct3 == 1)begin
            //lh
              result_next = dataRd & 65535;
            end
            
          end
          
        end
      endcase
  end
  
  
endmodule