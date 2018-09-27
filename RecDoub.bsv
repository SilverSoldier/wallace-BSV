import Vector::*;
interface RecDoub;
  method Action prefixSum(Bit#(8) a);
  method Bit#(1) getSum();
endinterface

module mkRD (RecDoub);
  Vector#(8, Reg#(Bit#(1))) x <- replicateM(mkReg(0));
  Reg#(int) offset <- mkReg(8);

  rule recursive_doubling(offset < 8);
  	for(Int#(32) i = 0; i < 8; i = i+1) begin
  	  if(i > offset) begin
  	  	x[i] <= x[i] & x[i - offset];
  	  end
  	  $write("%b ", x[i]);
  	end
  	$display(" ");
  	offset <= offset * 2;
  endrule

  method Action prefixSum(Bit#(8) a);
  	for(Int#(32) i = 0; i < 8; i = i+1) begin
  	  x[i] <= a[i];
  	end
  	offset <= 1;
  	$display("1");
  endmethod

  method Bit#(1) getSum() if(offset == 8);
  	return x[7];
  endmethod
endmodule
