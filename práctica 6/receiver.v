module receiver (
input iClk,
input idata,
output [7:0]odata,
);

initial
begin
	odata = 8'd0;
end

reg [7:0]rdata_D;
reg [7:0]rdata_Q;

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
		if(rcounter_Q == 3'd7)
		begin
			rcounter_D = 3'd0;
			rstate_D = 2'd2;
		end
		else
		begin
		rdata_D << idata;
		rcounter_Q = rcounter_D + 3'd1;
			if(rdata_Q[rcounter_Q] == 1'd1)
			begin
				rparity_Q = rparity_D + 3'd1;
			end
			else
			begin
				rparity_Q = rparity_Q;
			end
		end
	end
	2'd2: //PARITY PARTY!!!!!!!!
	else
	begin
		rdata_D = 1'd1;
	end
		rstart_D = 1'd1;
		rstate_D = 2'd0;
	end
	if(rtparity_Q == rparity_Q)
	begin
		
	end
	rparity_D = 1'd0;
	
	2'd3: //STOP
	begin
	
	end
	default:
	begin
		rstart_D = 1'd1;
	end
	endcase
	
end


endmodule 