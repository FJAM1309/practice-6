module transmitter (
input [7:0]idata,
input iEN,
//input iBPS,
input iClk,
output odata
);

reg [7:0]rinput_D;
reg [7:0]rinput_Q;

reg rdata_D = 1'd1;
reg rdata_Q;

reg [2:0]rstate_D;
reg [2:0]rstate_Q;

reg [3:0]rcounter_D;
reg [3:0]rcounter_Q;

reg [7:0]rparity_D;
reg [7:0]rparity_Q;


assign odata = rdata_Q;

initial 
begin
	rdata_D = 1'd1;
end

always @ (posedge iClk)
begin
	rcounter_Q <= rcounter_D;
	rparity_Q <= rparity_D;
	rinput_Q <= rinput_D;
//if(iBPS)
	rdata_Q <= rdata_D;
//else
//	rdata_Q <= rdata_Q;
//end

always @ * 
begin
	case(rstate_Q)
	2'd0: //IDLE
	begin
		if(iEN)
		begin
		rinput_D = idata;
		rstate_D = 2'd1;
		end
	end
	2'd1: //START
	begin
		rdata_D = 1'd0;
		rstate_D = 2'd2;
	end
	2'd2: //DATA
	begin
		if(rcounter_Q == 3'd7)
		begin
			if (rparity_D % 2 == 1) // paridad par o impar
			begin
				rdata_D = 1'd0; //impar
			end
			else
			begin
				rdata_D = 1'd1; //par
			end
			rcounter_D = 3'd0; 
			rstate_D = 2'd3; //sig edo.
		end
		else
		begin
			rdata_D = rinput_D[rcounter_Q];
			rcounter_Q = rcounter_D + 3'd1;
			if(rdata_D == 1'd1)
			begin
				rparity_Q = rparity_D + 1'd1;
			end
			else
			begin
				rparity_Q = rparity_D;
			end
		end
	end
		2'd3: //STOP
		begin
			rdata_D = 1'd0;
			rstate_D = 3'd0;
		default:
		begin
			rdata_D = 1'd1;
		end
	endcase
end

endmodule 