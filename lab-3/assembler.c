#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    
    FILE *input,*output_hex, *output_bin;
    char output_file4hex[256];
    char output_file4bin[256];

    if (argc != 2){
    	fprintf(stderr,"Please provide an input file! (e.g., exercise1.s \n");
    	fprintf(stderr,"Example Usage: ./assembler exercise1.s\n");
        return -1;
    }
    
    input = fopen(argv[1],"r");
    const char *dot = strrchr(argv[1], '.'); //get the name of the file to generate output files
    if (dot) {
        // Copy the part before the extension
        size_t basename_len = dot - argv[1];
        strncpy(output_file4hex, argv[1], basename_len);
        strncpy(output_file4bin, argv[1], basename_len);
        output_file4hex[basename_len] = '\0';
        output_file4bin[basename_len] = '\0';

        // Append proper suffix
        strcat(output_file4hex, ".hex");
        strcat(output_file4bin, ".bin");
    }else{
    	fprintf(stderr,"Please provide a proper input file (with suffix \".s\")\n");
        return -1;
    }
        
    output_hex = fopen(output_file4hex,"w"); //this will open an output file to keep instructions in hex form as a text
    output_bin = fopen(output_file4bin,"wb"); //this will open an output file to keep instructions in hex form as a binary

    if( input == NULL || output_hex == NULL || output_bin == NULL) {
        fprintf(stderr,"Couldn't access file\n");
        return -1;
    }

    char hex_instruction[9];
    char buffer[100], current_ins[10];
    uint32_t opcode, funct3, funct7, rs1, rs2, rd, imm12, imm20, hex;

    while (fgets(buffer, 100, input) != NULL) {
        if (sscanf(buffer, "%s", current_ins) != 1) continue;

        if (!strcmp(current_ins, "add") || !strcmp(current_ins, "sub") || !strcmp(current_ins, "and") ||
            !strcmp(current_ins, "or") || !strcmp(current_ins, "xor") || !strcmp(current_ins, "sll") ||
            !strcmp(current_ins, "srl") || !strcmp(current_ins, "slt")) {

            sscanf(buffer, "%*s x%d, x%d, x%d", &rd, &rs1, &rs2);
            opcode = 0x33;
            funct7 = (!strcmp(current_ins, "sub") ? 0x20 : 0x00);
            if (!strcmp(current_ins, "add") || !strcmp(current_ins, "sub")) funct3 = 0x0;
            else if (!strcmp(current_ins, "sll")) funct3 = 0x1;
            else if (!strcmp(current_ins, "slt")) funct3 = 0x2;
            else if (!strcmp(current_ins, "xor")) funct3 = 0x4;
            else if (!strcmp(current_ins, "srl")) funct3 = 0x5;
            else if (!strcmp(current_ins, "or"))  funct3 = 0x6;
            else if (!strcmp(current_ins, "and")) funct3 = 0x7;
            hex = opcode | (rd << 7) | (funct3 << 12) | (rs1 << 15) | (rs2 << 20) | (funct7 << 25);
            printf("%s x%d, x%d, x%d\n", current_ins, rd, rs1, rs2);

        } else if (!strcmp(current_ins, "addi") || !strcmp(current_ins, "andi") || !strcmp(current_ins, "ori") ||
                   !strcmp(current_ins, "xori") || !strcmp(current_ins, "slli") || !strcmp(current_ins, "srli") ||
                   !strcmp(current_ins, "slti")) {

            sscanf(buffer, "%*s x%d, x%d, %d", &rd, &rs1, &imm12);
            opcode = 0x13;
            if (!strcmp(current_ins, "addi")) funct3 = 0x0;
            else if (!strcmp(current_ins, "slli")) funct3 = 0x1;
            else if (!strcmp(current_ins, "slti")) funct3 = 0x2;
            else if (!strcmp(current_ins, "xori")) funct3 = 0x4;
            else if (!strcmp(current_ins, "srli")) funct3 = 0x5;
            else if (!strcmp(current_ins, "ori"))  funct3 = 0x6;
            else if (!strcmp(current_ins, "andi")) funct3 = 0x7;
            hex = opcode | (rd << 7) | (funct3 << 12) | (rs1 << 15) | ((imm12 & 0xFFF) << 20);
            printf("%s x%d, x%d, %d\n", current_ins, rd, rs1, imm12);

        } else if (!strcmp(current_ins, "mv")) {
            sscanf(buffer, "%*s x%d, x%d", &rd, &rs1);
            imm12 = 0;
            opcode = 0x13; funct3 = 0x0;
            hex = opcode | (rd << 7) | (funct3 << 12) | (rs1 << 15);
            printf("mv x%d, x%d\n", rd, rs1);

        } else if (!strcmp(current_ins, "li")) {
            sscanf(buffer, "%*s x%d, %d", &rd, &imm12);
            rs1 = 0;
            opcode = 0x13; funct3 = 0x0;
            hex = opcode | (rd << 7) | (funct3 << 12) | (rs1 << 15) | ((imm12 & 0xFFF) << 20);
            printf("li x%d, %d\n", rd, imm12);

        } else if (!strcmp(current_ins, "lb") || !strcmp(current_ins, "lw") || !strcmp(current_ins, "lh")) {
            sscanf(buffer, "%*s x%d, %d(x%d)", &rd, &imm12, &rs1);
            opcode = 0x03;
            if (!strcmp(current_ins, "lb")) funct3 = 0x0;
            else if (!strcmp(current_ins, "lh")) funct3 = 0x1;
            else funct3 = 0x2;
            hex = opcode | (rd << 7) | (funct3 << 12) | (rs1 << 15) | ((imm12 & 0xFFF) << 20);
            printf("%s x%d, %d(x%d)\n", current_ins, rd, imm12, rs1);

        } else if (!strcmp(current_ins, "sb") || !strcmp(current_ins, "sw") || !strcmp(current_ins, "sh")) {
            sscanf(buffer, "%*s x%d, %d(x%d)", &rs2, &imm12, &rs1);
            opcode = 0x23;
            if (!strcmp(current_ins, "sb")) funct3 = 0x0;
            else if (!strcmp(current_ins, "sh")) funct3 = 0x1;
            else funct3 = 0x2;
            uint32_t imm_4_0 = imm12 & 0x1F;
            uint32_t imm_11_5 = (imm12 >> 5) & 0x7F;
            hex = opcode | (imm_4_0 << 7) | (funct3 << 12) | (rs1 << 15) | (rs2 << 20) | (imm_11_5 << 25);
            printf("%s x%d, %d(x%d)\n", current_ins, rs2, imm12, rs1);

        } else if (!strcmp(current_ins, "beq") || !strcmp(current_ins, "bne") || !strcmp(current_ins, "blt") || !strcmp(current_ins, "bge")) {
            sscanf(buffer, "%*s x%d, x%d, %d", &rs1, &rs2, &imm12);
            opcode = 0x63;
            if (!strcmp(current_ins, "beq")) funct3 = 0x0;
            else if (!strcmp(current_ins, "bne")) funct3 = 0x1;
            else if (!strcmp(current_ins, "blt")) funct3 = 0x4;
            else if (!strcmp(current_ins, "bge")) funct3 = 0x5;
            uint32_t imm_11 = (imm12 >> 11) & 0x1;
            uint32_t imm_4_1 = (imm12 >> 1) & 0xF;
            uint32_t imm_10_5 = (imm12 >> 5) & 0x3F;
            uint32_t imm_12 = (imm12 >> 12) & 0x1;
            hex = opcode | (imm_4_1 << 8) | (imm_10_5 << 25) | (rs1 << 15) |
                  (rs2 << 20) | (funct3 << 12) | (imm_11 << 7) | (imm_12 << 31);
            printf("%s x%d, x%d, %d\n", current_ins, rs1, rs2, imm12);

        } else if (!strcmp(current_ins, "lui") || !strcmp(current_ins, "auipc")) {
            sscanf(buffer, "%*s x%d, %d", &rd, &imm20);
            opcode = (!strcmp(current_ins, "lui")) ? 0x37 : 0x17;
            hex = opcode | (rd << 7) | (imm20 << 12);
            printf("%s x%d, 0x%x\n", current_ins, rd, imm20);

        } else if (!strcmp(current_ins, "jal")) {
            sscanf(buffer, "%*s x%d, %d", &rd, &imm20);
            opcode = 0x6F;
            uint32_t imm_20 = (imm20 >> 20) & 0x1;
            uint32_t imm_10_1 = (imm20 >> 1) & 0x3FF;
            uint32_t imm_11 = (imm20 >> 11) & 0x1;
            uint32_t imm_19_12 = (imm20 >> 12) & 0xFF;
            hex = opcode | (rd << 7) | (imm_19_12 << 12) | (imm_11 << 20) |
                  (imm_10_1 << 21) | (imm_20 << 31);
            printf("jal x%d, %d\n", rd, imm20);

        } else if (!strcmp(current_ins, "jalr")) {
            sscanf(buffer, "%*s x%d, %d(x%d)", &rd, &imm12, &rs1);
            opcode = 0x67; funct3 = 0x0;
            hex = opcode | (rd << 7) | (funct3 << 12) | (rs1 << 15) | ((imm12 & 0xFFF) << 20);
            printf("jalr x%d, %d(x%d)\n", rd, imm12, rs1);

        } else if (!strcmp(current_ins, "ecall")) {
            hex = 0x00000073;
            printf("ecall\n");

        } else {
            continue;
        }

        sprintf(hex_instruction, "%08x", hex);
        fprintf(output_hex, "%s\n", hex_instruction);

        uint32_t instruction = (uint32_t) strtol(hex_instruction, NULL, 16);
        for (int i = 0; i < 4; i++) {
            uint8_t byte = (instruction >> (i * 8)) & 0xFF;
            fwrite(&byte, sizeof(uint8_t), 1, output_bin);
        }
    }

    fclose(input);
    fclose(output_hex);
    fclose(output_bin);

    return 0;
}