module receiver (
input iClk,
input idata,
output [7:0]odata
);

initial
begin
	odata = 8'd0;
end

reg [7:0]rdata_D;
reg [7:0]rdata_Q;

reg [11:0]rRP_D;
reg [11:0]rRP_Q;

reg [2:0]rstate_D;
reg [2:0]rstate_Q;

reg [7:0]rparity_D;
reg [7:0]rparity_Q;

reg rtparity_D;
reg rtparity_Q;

reg [3:0]rcounter_D;
reg [3:0]rcounter_Q;

assign odata = rdata_Q;

always @ (posedge iClk)
begin
	rcounter_Q <= rcounter_D;
	rRP_Q <= rRP_D;
	rparity_Q <= rparity_D;
//if(iBPS)
	rdata_Q <= rdata_D;
//else
//	rdata_Q <= rdata_Q;
//end
end

always @ *
begin
	case(rstate_Q)
	
	2'd0:	//IDLE
	begin
		rdata_D = idata;
		if(rdata_D == 1'd0)
		begin
			rstate_D = 2'd1;
		end
	end
	2'd1: //START
	begin
		if(rcounter_Q == 4'd9)
		begin
			rtparity_D = idata;
		end
		if(rcounter_Q == 4'd12)
		begin
			rcounter_D = 4'd0;
			rstate_D = 2'd2;
		end
		else
		begin
			rRP_D << idata;
			rcounter_Q = rcounter_D + 4'd1;
			if(rRP_D[rcounter_Q] == 1'd1)
			begin
				rparity_Q = rparity_D + 4'd1;
			end
			else
			begin
				rparity_D = rparity_Q;
			end
		end
	end
	2'd2: //PARITY PARTY!!!!!!!!
	if (rRP_Q % 2 == 1) // paridad par o impar
	begin
		rparity_D = 1'd0; //impar
	end
	else
	begin
		rparity_D = 1'd1; //par
	end
	if(rtparity_Q == rparity_Q)
	begin
		rdata_D = rRP_D;
		rstate_D = 3'd3;
	end
	else
	begin
		rstate_D = 1'd0;
	end
	
	2'd3: //STOP
	begin
		rdata_D = 1'd1;
		rstate_D = 3'd0
	end
	default:
	begin
		rdata_D = 1'd1;
	end
	endcase
	
end


endmodule 