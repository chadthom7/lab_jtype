
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module CSCE611_lab_jtype(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,

	//////////// LED //////////
	output		     [8:0]		LEDG,
	output		    [17:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		    [17:0]		SW,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,
	output		     [6:0]		HEX6,
	output		     [6:0]		HEX7
);
// use this file for over all functionallity of the project, top.sv is just an example
// TODO : Read SW into gpio_in
//=======================================================
//  REG/WIRE declarations
//=======================================================
	// Input from switch
	reg [31:0] GPIO_in; 
	// Output
	reg [31:0] GPIO_out;
	/*The value read from GPIO (in `sra`) will be stored in the destination
	  register (rd).
	The value written to GPIO (in `srl`) will be sourced from the source
	  register (rs).
	*/
	logic [55:0] segs;
	/* 8 displays of 7 bits, 8*7=56
	   make for loop to assign all hex displays instead of typing 8 hexdriver instantiations
	*/
//=======================================================
//  Structural coding
//=======================================================
	assign GPIO_in = {14'b0, SW}; // GPIO_in is 32 bits, switch is 18
	//cpu cpu(.clk(CLOCK_50), .rst(~KEY[0]), .gpio_in(GPIO_in), .gpio_out(GPIO_out));

	assign {HEX7,HEX6,HEX5,HEX4,HEX3,HEX2,HEX1,HEX0} = segs;
	genvar i;
	generate
	for (i=0;i<8;i=i+1) begin : decoders
		hexdriver mydecoder(.val(GPIO_out[i*4+3:i*4]),.HEX(segs[i*7+6:i*7]));
	end
	endgenerate


endmodule