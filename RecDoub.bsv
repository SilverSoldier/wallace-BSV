interface RecDoub;
  method Action prefixSum(Bit#(8) a);
  method Bit#(1) getSum();
endinterface

module mkRD (RecDoub);
  Reg#(Bit#(1)) x_old[8];
  Reg#(Bit#(1)) x_new[8];
  Reg#(Bool) init_done <- mkReg(False);
  Reg#(Int#(32)) next[8];
  Reg#(Int#(32)) start <- mkReg(8);

  rule init(init_done == False);
  	/* $display("2"); */
  	for (Int#(32) i = 0; i < 8; i = i+1) begin
  	  next[i] <= (i - 1);
  	  $write("%d ", i);
  	end
  	init_done <= True;
  	/* $display("3, %b", next[7]); */
  endrule

  rule recursive_doubling(start < 8 && init_done == True && next[0] >= -1);
  	/* $display("A"); */
  	for(Int#(32) i = 0; i < 8; i = i+1) begin
  	  $write("H: %d, ", next[i]);
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
  	  	$write("%d, %b, %d", i, x_old[i], next[i]);
  	end
  	$display("");
  endrule

  method Action prefixSum(Bit#(8) a);
  	for(Int#(32) i = 0; i < 8; i = i+1) begin
  	  x_old[i] <= a[i];
  	end
  	start <= 1;
  	$display("1");
  endmethod

  method Bit#(1) getSum() if(start == 8);
  	return x_old[7];
  endmethod
endmodule
