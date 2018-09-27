import Vector::*;
`define n 8

`define res 9
interface CLAn;
  method Action add(Bit#(`n) a, Bit#(`n) b);
  method Bit#(`res) getSum();
endinterface

module mkCLAn(CLAn);
  Reg#(Bit#(`n)) sum <- mkReg(0);
  Vector#(`n, Reg#(bit)) cs0 <- replicateM(mkReg(0));
  Vector#(`n, Reg#(bit)) cs1 <- replicateM(mkReg(0));

  Reg#(int) offset <- mkReg(`n);

  rule recursive_doubling(offset < `n);
  	for(Int#(32) i = 0; i < `n; i = i+1) begin
  	  if(i > offset) begin
  	  	$write("x%dx", i);
  		cs0[i] <= cs0[i] | (cs0[i - offset] & cs1[i]);
  	  	cs1[i] <= cs0[i] | (cs1[i - offset] & cs1[i]);
  	  end
  	end
  	offset <= offset * 2;
  	for(Int#(32) i = 0; i < `n; i = i+1) begin
  	  $write("%b%b ", cs0[i], cs1[i]);
  	end
  $display(" ");
  endrule

  method Action add(Bit#(`n) a, Bit#(`n) b);
  	// if first is a propogate, make it a kill
  	cs0[0] <= a[0] & b[0];
  	cs1[0] <= a[0] & b[0];
  	for(Int#(32) i = 1; i < `n; i = i+1) begin
  	  cs0[i] <= a[i] & b[i];
  	  cs1[i] <= a[i] | b[i];
  	end
  	offset <= 1;
  	sum <= a ^ b;
  endmethod

  method Bit#(`res) getSum() if(offset == `n);
  	Vector#(`res, bit) result;
  	result[0] = sum[0];
  	for(Int#(32) i = 1; i < `n; i = i+1) begin
  	  // xor of sum and carry left shifted
  	  result[i] = cs0[i-1] ^ sum[i];
  	end
  	result[`res-1] = cs0[`n-1];
  	return pack(result);
  endmethod
endmodule
