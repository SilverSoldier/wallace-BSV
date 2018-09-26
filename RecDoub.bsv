interface RecDoub;
  method Action prefixSum(Bit#(8) a);
  method Bit#(1) getSum();
endinterface

module mkRD (RecDoub);
  Reg#(Bit#(1)) x_old[8];
  Reg#(Bit#(1)) x_new[8];
  Reg#(Bool) running <- mkReg(True);
  Reg#(Int#(32)) next[8];
  Reg#(Int#(32)) start <- mkReg(8);

  rule init(running == True);
  	$display("2");
  	running <= False;
  	start <= 1;
  	for (Int#(32) i = 0; i < 8; i = i+1) begin
  	  let temp = i - 1;
  	  next[i] <= temp;
  	end
  	$display("3, %b", next[7]);
  endrule

  rule recursive_doubling(start < 8);
  	$display("A");
  	for(Int#(32) i = 0; i < 8; i = i+1) begin
  	  if(start < 8 && next[i] != -1) begin
  	  	let temp = next[i];
  	  	let temp_x = x_old[i];
  	  	x_new[i] <= temp_x & x_old[temp];
  	  	/* Update the next values */
  	  	next[i] <= next[temp];
  	  end
  	end
  	start <= start * 2;
  	for(Int#(32) i = 0; i < 8; i = i+1) begin
  	  	x_old[i] <= x_new[i];
  	  	$display("%x", x_old);
  	end
  endrule

  method Action prefixSum(Bit#(8) a);
  	$display("1");
  	for(Int#(32) i = 0; i < 8; i = i+1) begin
  	  x_old[i] <= a[i];
  	end
  endmethod

  method Bit#(1) getSum() if(start == 8);
  	return x_old[7];
  endmethod
endmodule
