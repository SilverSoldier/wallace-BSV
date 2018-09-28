import CLA::*;
import Vector::*;
import CRA::*;
`define n 8

`define ppn 10

`define res 15

module mkCRA(CRA#(n));
  method Bit#(n) sum(Bit#(n) a, Bit#(n) b, Bit#(n) c);
  	return a & b | b & c | c & a;
  endmethod

  method Bit#(n) carry(Bit#(n) a, Bit#(n) b, Bit#(n) c);
  	return a ^ b ^ c;
  endmethod
endmodule

module mkWallaceN();
  // n-partial products - each a 2n-1 bit no.
  Vector#(`ppn, Reg#(Bit#(`res))) partial_products <- replicateM(mkReg(0));
  Bit#(`n) a = 8'b00001111;
  Bit#(`n) b = 8'b00000001;
  Bit#(`n) b = 8'b00001001;
  Reg#(Bool) start <- mkReg(True);
  CRA#(`res) cra <- mkCRA();
  Reg#(Int#(32)) size <- mkReg(`n);
  CLAn cla <- mkCLAn();

  rule init(start == True);
  	cra.sum(extend(a), extend(b), extend(c));
  	for(Int#(32) i = 0; i < `n; i = i+1) begin
  	  if(b[i] == 1)
  	  	partial_products[i] <= extend(a);
  	end
  	start <= False;
  endrule

  rule add_partial_products(start == False && size > 2);
  	for(Int#(32) i = 0; i < `n; i = i+3) begin
  	  Int#(32) loc = i/3 * 2;
  	  /* $display("loc: %d ", loc); */
  	  if(i < size - 2) begin
  	  	let sum = cra.sum(partial_products[i], partial_products[i+1], partial_products[i+2]);
  	  	let carry = cra.carry(partial_products[i], partial_products[i+1], partial_products[i+2]);

  	  	partial_products[loc] <= sum;
  	  	partial_products[loc+1] <= carry;
  	  end
  	  else begin
  	  	partial_products[loc] <= partial_products[i];
  	  	if(i < size - 1)
  	  	  partial_products[loc+1] <= partial_products[i+1];
  	  end
  	end
  	size <= size/3 * 2 + size%3;
  	$display("size: %d", size);
  endrule

  rule finish(size == 2);
  	// Apply CLA on the remaining 2 nos.
  	cla.add(partial_products[0], partial_products[1]);
  	let prod = cla.getSum();
  	$display("%b", prod);
  	$finish(0);
  endrule

endmodule
