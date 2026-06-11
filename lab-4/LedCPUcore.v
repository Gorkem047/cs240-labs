module LedCPUcore(
	clk,
	rst,
	addrRd,
	dataRd,
	outPattern
    );
input clk,rst;
output reg [7:0] addrRd;
input [15:0] dataRd;
output reg [7:0] outPattern;

reg [7:0] addrRdNext;
reg [7:0] outPatternNext;
reg [7:0] processTime, processTimeNext;

always@(posedge clk) begin
    addrRd <= addrRdNext;
    outPattern <= outPatternNext;
    processTime <= processTimeNext;
end

always@(*) begin
    if(rst) begin
        addrRdNext = 8'd0;
        outPatternNext = 8'd0;
        processTimeNext = 8'd0;
    end else begin
        if(processTime == 0) begin
            if(dataRd[7:0] == 0) begin
                addrRdNext = dataRd[15:8];
                outPatternNext = outPattern;
                processTimeNext = 8'd0;
            end else begin
                addrRdNext = addrRd + 1;
                outPatternNext = dataRd[15:8];
                processTimeNext = dataRd[7:0] - 1;
            end
        end else begin
            addrRdNext = addrRd;
            outPatternNext = outPattern;
            processTimeNext = processTime - 1;
        end
    end
end
endmodule
