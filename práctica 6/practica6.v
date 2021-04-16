module practice6(
input iClk,
input iEN,
input [7:0]idata,
output [6:0]oS1,
output [6:0]oS2,
output [6:0]oS3
);

wire [3:0] BCD1;
wire [3:0] BCD2;
wire [3:0] BCD3;
wire BaudRate;
wire data;
wire [7:0]number;

/*

frec_divider BaudRate(
.iClk (iClk),
.ofrec (BaudRate)
);

*/
transmitter Transmisor(
.idata (idata),
.iEN (iEN),
//.iBPS (BaudRate),
.iClk (iClk),
.odata (data)
);

receiver Receiver(
.iClk (iClk),
.idata (data),
.odata (number)
);

counter Separador(
.iClk (iClk),
.idata (number)
.oSalida1 (BCD1),
.oSalida2 (BCD2),
.oSalida3 (BCD3)
);

BCD BCD1(
.iClk (iClk),
.iE (BCD1),
.oS (oS1)
);

BCD BCD2(
.iClk (iClk),
.iE (BCD2),
.oS (oS1)
);

BCD BCD3(
.iClk (iClk),
.iE (BCD3),
.oS (oS1)
);

endmodule 