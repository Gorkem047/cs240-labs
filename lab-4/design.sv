module riscv_decoder(
  clk,
  rst,
  in,
  opcode,
  rd,
  funct3,
  rs1,
  rs2,
  funct7,
  imm12,
  imm20,
  aluControl,
  regWrite, 
  aluSrcA, 
  aluSrcB, 
  memWrite, 
  branch, 
  jump,
  immSrc, 
  resultSrc, 
  aluOP
);
  
  input clk, rst;
  input [31:0] in;
  output reg [6:0] opcode, funct7;
  output reg [4:0] rd, rs1, rs2;
  output reg [2:0] funct3, aluControl;
  output reg [11:0] imm12;
  output reg [19:0] imm20;
  output reg regWrite, aluSrcA, aluSrcB, memWrite, branch, jump;
  output reg [1:0] immSrc, resultSrc, aluOP;
  
  reg [6:0] opcode_next, funct7_next;
  reg [4:0] rd_next, rs1_next, rs2_next;
  reg [2:0] funct3_next, aluControl_next;
  reg [11:0] imm12_next;
  reg [19:0] imm20_next;
  reg regWrite_next, aluSrcA_next, aluSrcB_next, memWrite_next, branch_next, jump_next;
  reg [1:0] immSrc_next, resultSrc_next, aluOP_next;

  always @(posedge clk) begin
    opcode     <= opcode_next;
    rd         <= rd_next;
    funct3     <= funct3_next;
    rs1        <= rs1_next;
    rs2        <= rs2_next;
    funct7     <= funct7_next;
    imm12      <= imm12_next;
    imm20      <= imm20_next;
    aluControl <= aluControl_next;
    regWrite   <= regWrite_next;
    aluSrcA    <= aluSrcA_next;
    aluSrcB    <= aluSrcB_next;
    memWrite   <= memWrite_next;
    branch     <= branch_next;
    jump       <= jump_next;
    immSrc     <= immSrc_next;
    resultSrc  <= resultSrc_next;
    aluOP      <= aluOP_next;
  end

  always @* begin
    if (rst) begin
      opcode_next     = 0;
      rd_next         = 0;
      funct3_next     = 0;
      rs1_next        = 0;
      rs2_next        = 0;
      funct7_next     = 0;
      imm12_next      = 0;
      imm20_next      = 0;
      aluControl_next = 0;
      regWrite_next   = 0;
      aluSrcA_next    = 0;
      aluSrcB_next    = 0;
      memWrite_next   = 0;
      branch_next     = 0;
      jump_next       = 0;
      immSrc_next     = 0;
      resultSrc_next  = 0;
      aluOP_next      = 0;
    end else begin
      opcode_next     = in[6:0];
      rd_next         = in[11:7];
      funct3_next     = in[14:12];
      rs1_next        = in[19:15];
      rs2_next        = in[24:20];
      funct7_next     = in[31:25];
      imm12_next      = in[31:20];
      imm20_next      = {in[31], in[19:12], in[20], in[30:21], 1'b0};

      case (in[6:0])
        7'b0000011: begin // lw
          regWrite_next   = 1;
          aluSrcA_next    = 0;
          aluSrcB_next    = 1;
          memWrite_next   = 0;
          resultSrc_next  = 2'b01;
          branch_next     = 0;
          aluOP_next      = 2'b00;
          jump_next       = 0;
          immSrc_next     = 2'b00;
          aluControl_next = 3'b000;
        end
        7'b0100011: begin // sw
          regWrite_next   = 0;
          aluSrcA_next    = 0;
          aluSrcB_next    = 1;
          memWrite_next   = 1;
          resultSrc_next  = 2'b00;
          branch_next     = 0;
          aluOP_next      = 2'b00;
          jump_next       = 0;
          immSrc_next     = 2'b01;
          aluControl_next = 3'b000;
          imm12_next      = {in[31:25], in[11:7]};
        end
        7'b0110011: begin // R-type
          regWrite_next   = 1;
          aluSrcA_next    = 0;
          aluSrcB_next    = 0;
          memWrite_next   = 0;
          resultSrc_next  = 2'b00;
          branch_next     = 0;
          aluOP_next      = 2'b10;
          jump_next       = 0;
          immSrc_next     = 2'b00;
          case (in[14:12])
            3'b000: aluControl_next = (in[30] == 1) ? 3'b001 : 3'b000; // sub/add
            3'b010: aluControl_next = 3'b101; // slt
            3'b110: aluControl_next = 3'b011; // or
            3'b111: aluControl_next = 3'b010; // and
            default: aluControl_next = 3'b000;
          endcase
        end
        7'b1100011: begin // beq
          regWrite_next   = 0;
          aluSrcA_next    = 0;
          aluSrcB_next    = 0;
          memWrite_next   = 0;
          resultSrc_next  = 2'b00;
          branch_next     = 1;
          aluOP_next      = 2'b01;
          jump_next       = 0;
          immSrc_next     = 2'b10;
          aluControl_next = 3'b001;
          imm12_next      = {in[31], in[7], in[30:25], in[11:8], 1'b0};
        end
        7'b0010011: begin // I-type ALU
          regWrite_next   = 1;
          aluSrcA_next    = 0;
          aluSrcB_next    = 0;
          memWrite_next   = 0;
          resultSrc_next  = 2'b00;
          branch_next     = 0;
          aluOP_next      = 2'b10;
          jump_next       = 0;
          immSrc_next     = 2'b00;
          imm12_next      = in[31:20];
          case (in[14:12])
            3'b000: aluControl_next = 3'b000; // addi
            3'b010: aluControl_next = 3'b101; // slti
            3'b110: aluControl_next = 3'b011; // ori
            3'b111: aluControl_next = 3'b010; // andi
            default: aluControl_next = 3'b000;
          endcase
        end
        7'b1101111: begin // jal
          regWrite_next   = 1;
          aluSrcA_next    = 0;
          aluSrcB_next    = 0;
          memWrite_next   = 0;
          resultSrc_next  = 2'b10;
          branch_next     = 0;
          aluOP_next      = 2'b00;
          jump_next       = 1;
          immSrc_next     = 2'b11;
        end
        default: begin
          // do nothing
        end
      endcase
    end
  end

endmodule
