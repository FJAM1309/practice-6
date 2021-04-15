module transmitter (
input [7:0]idata,
input iEN,
input iBPS
input iClk,
output odata
);

reg [7:0]rdata_D;
reg [7:0]rdata_Q;

reg [2:0]rstate_D;
reg [2:0]rstate_Q;

reg [3:0]rcounter_D;
reg [3:0]rcounter_Q;

reg rparity_D;
reg rparity_Q;

reg rstart_D;
reg rstart_Q;

assign odata = rdata_Q;

initial 
begin
	rstart_D = 1'd1;
end

always @ (iClk)
begin
	rcounter_Q <= rcounter_D;
	rstart_Q <= rstart_D;
	rparity_Q <= rparity_D;
if(iBPS)
	rdata_Q <= rdata_D;
else	
	rdata_Q <= rdata_Q;
end

always @ * 
begin
	case(rstate_Q)
	2'd0: //IDLE
	begin
		rdata_D = idata;
		rcounter_D = 3'd0;
		if(iEN)
		begin
		rstate_D = 2'd1;
		end
	end
	2'd1: //START
	begin
		rstart_D = 1'd0;
		rstate_D = 2'd2;
	end
	2'd2: //DATA
	begin
		if(rcounter_Q == 3'd7)
		begin
			rstate_D = 2'd3;
		end
		else
		begin
			rcounter_Q = rcounter_D + 3'd1;
			rdata_D = idata[rcounter_Q];
		end
	end
	2'd3: //STOP
	begin
		if(rdata_D % 2)
		begin
			rparity_Q = 1'd0;
		end
		rstart_D = 1'd1;
		rstate_D = 2'd0;
	end
	default:
	begin
		rstart_D = 1'd1;
	end
	endcase
end

endmodule 