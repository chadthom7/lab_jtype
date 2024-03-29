module controlUnit (

input clk, rst,

input logic [5:0] i_type,

input logic [4:0] shamt /* <-instruction_EX[10:6] */ , 

input logic [5:0] function_code /* <-instruction_EX[5:0] 6 bits not 5*/ ,

output logic [3:0] alu_op, // op_EX

output logic [4:0] shamt_EX, // shamt_EX[4:0] 

output logic enhilo_EX, 	// only 1 for mult/multu


output logic [1:0] regsel_EX,	// indicates alu to write to Hi and lo
					// 1 for mfhi, 2 for mflo, 0 everything else

output logic regwrite_EX,



output logic rdrt_EX, // selects register write addr // chooses destination of result
			// instr[20:16] for I and instr[15:11] for R
			// 1 for I, 0 for R

// add regdest_WB?
output logic memwrite_EX, // set to 1 for SW

//alusrc //determines what b alu uses; readdata1, readdata2, instr[15:11]
output logic [1:0] alu_src_EX,

output logic GPIO_OUT, //en

output logic GPIO_IN,
input logic stall_FETCH //en

);


// enhilo_EX 		// Assert for mult / multu instructions

// regsel_EX 		// 1 for mfhi, 2 for mflo, 0 for everything else

// Control Unit Logic

	//always_ff @(posedge clk, posedge rst) begin
	always_comb begin      //always @(*) begin
		// alu_op = 4'b0000; // '0000' is op code for AND
		// regsel_EX = 2'b00;
		// regwrite_EX = 1'b0;			   // don't write a register
		// shamt_EX = instruction_EX[10:6]; // For sll, srl, sra, 'X' for everything else
		// enhilo = 1'b0;

		// GPIO_out_en = 1'b0;
		
		// For Jump and Branch Instructions (I-Type)
		// pc_src_EX = 2'b0;
		// alu_src_EX = 2'b0;
		// rdrt_EX = 1'b0;
		// stall_FETCH = 1'b0;


		if (~stall_FETCH && ~rst) begin

			//Empty input  //trying to make sure regwrite_EX/WB = 0 when it should
		/*
			if (i_type == 6'd0 && function_code == 6'd0) begin
				alu_op = 4'bXXXX;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'bX;
				regsel_EX = 2'bXX; //0 for I-types, unless LW
				regwrite_EX = 1'b0;
				rdrt_EX = 1'bX; // rt destination
				memwrite_EX = 1'bX;
				alu_src_EX = 2'dX;  // sign extend
				GPIO_OUT = 1'bX;
				GPIO_IN = 1'bX;	
		*/	// ADD
			if (i_type == 6'd0 && (function_code == 6'b100000 |
				function_code == 6'b100001)) begin
				alu_op = 4'b0100; // op_EX
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; // = to 2 for R, unless GPIO, or deal with hi and lo
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
			
			// SUB
			end else if (i_type == 6'd0 && function_code == 6'b100010 |
				function_code == 6'b100011) begin
				alu_op = 4'b0101;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// MULT (signed)
			end else if (i_type == 6'd0 && function_code == 6'b011000) begin
				alu_op = 4'b0110;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b1; // 1 for MULT
				regsel_EX = 2'b00;
				regwrite_EX = 1'b0;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// MULTU (unsigned)
			end else if (i_type == 6'd0 && function_code == 6'b011001) begin
				alu_op = 4'b0111;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b1; // 1 for MULT
				regsel_EX = 2'b00;
				regwrite_EX = 1'b0;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
				
			// AND 
			end else if (i_type == 6'd0 && function_code == 6'b100100) begin 
				alu_op = 4'b0000;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// OR 
			end else if (i_type == 6'd0 && function_code == 6'b100101) begin 
				alu_op = 4'b0001;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// NOR
			end else if (i_type == 6'd0 && function_code == 6'b100111) begin 
				alu_op = 4'b0010;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// XOR
			end else if (i_type == 6'd0 && function_code == 6'b100110) begin 
				alu_op = 4'b0011;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;	
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// SLL
			end else if (i_type == 6'd0 && shamt!= 5'd0 && function_code == 6'b000000) begin 
				alu_op = 4'b1000;
				shamt_EX = shamt;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;	
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// SRL 
			end else if (i_type == 6'd0 && function_code == 6'b000010 &&
				shamt != 5'd0) begin 
				alu_op = 4'b1001;
				shamt_EX = shamt;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;


			// srl (gpio write) (shamt == 0)
			end else if (i_type == 6'd0 && function_code == 6'b000010 &&
				shamt == 5'd0) begin 
				alu_op = 4'bXXXX;
				shamt_EX = 5'dX;

				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; // select register to write to (rs) 
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				
				GPIO_OUT = 1'b1; // WRITE TO GPIO OUT
				GPIO_IN = 1'b0;
			


			// SRA 
			end else if (i_type == 6'd0 && function_code == 6'b000011 &&
				shamt != 5'd0) begin 
				alu_op = 4'b1010;
				shamt_EX = shamt;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;	
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0;
				alu_src_EX = 2'd0;

				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;


			// sra (gpio read)
			end else if (i_type == 6'd0 && function_code == 6'b000011 &&
					shamt == 5'd0) begin
				alu_op = 4'dX; 
				shamt_EX = 5'dX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; 
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				

				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b1;	  // READ FROM GPIO IN
			


			// MFHI 
			end else if (i_type == 6'd0 && function_code == 6'b010000) begin 
				alu_op = 4'bXXXX; //shouldn't neep op
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b01;
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// MFLO
			end else if (i_type == 6'd0 && function_code == 6'b010010) begin 
				alu_op = 4'bXXXX; //shouldn't neep op
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b10;
				regwrite_EX = 1'b1;	
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// SLT
			end else if (i_type == 6'd0 && function_code == 6'b101010) begin 
				alu_op = 4'b1100;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;	
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// SLTU
			end else if (i_type == 6'd0 && function_code == 6'b101011) begin 
				alu_op = 4'b1101;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b1;	
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
			// NOP
			
			end else if (i_type == 6'd0 && shamt== 5'd0 && function_code == 6'b000000) begin 
				alu_op = 4'bXXXX;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00;
				regwrite_EX = 1'b0;	
				rdrt_EX = 1'b0;
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'd0;
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
			
			/*
			10 outputs required for every case:
				-(4)				
				alu_op = 4'bXXXX;
				shamt_EX = 5'bX;
				enhilo_EX = 1'b0;
				regwrite_EX = 1'b1; // all besides mults
				
				-(2)default for all besides sll and sra:
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
				
				-(3)Itype signals, default vals for R-type instructions:
				memwrite_EX = 1'b0; 
				alu_src_EX = 2'b0;
				rdrt_EX = 1'b0;
				
				-(1)  For mflo=2, mfhi=1. Default for the rest:
				regsel_EX = 2'b00;

			*/
			/*
				alu_op = 4'b0100; // op_EX
				shamt_EX = 5'bXXXXX;  //dont shift
				enhilo_EX = 1'b0;    //not mults only   
				regsel_EX = 2'b00;	//only  for mflo mfhi gpio, else 0
				regwrite_EX = 1'b1; //all besides mults
				rdrt_EX = 1'b0;  //0 for R, 1 for I// handles immediate val
				memwrite_EX = 1'b0; // not going to use anymore

				alu_src_EX = 2'b00;  // used in I-type - default 0
				GPIO_OUT = 1'b0;  //1 for srl
				GPIO_IN = 1'b0;	 // 1 for sra			
			*/

			// alusrc tells whether to do sign,extend and zero extend... the most sig-bit will be captured in the cpu
			// when value is alusrc = 1 consider sign, = 2 or 3 consider zero, = 0 just pass RD2 directly
			

	//------------------------- I-TYPE -------------lui,adi,addiu,andi,ori,xori,slti----//
		 	/*
				
				OUTPUT from ALU is captured as lo_ex and hi_ex
					some of this logic is already written in the WB stage in cpu
				regsel_EX logic: (from page 32 in slides)
					if 0 take normal output from alu (lo_EX)
					if 1 which is only for mfhi take (hi_EX)
					if 2 which is only for mflo take (lo_EX)
					
				regsel_WB logic:
					regsel_WB <= regsel_EX		// This is right

				I would implement regsel_EX = 3 for sra to read GPIO-in to regfile, but we are using GPIO_in_en already
					//if 3 which is only for sra take (GPIO_in)
			*/
			// lui
			end else if (i_type == 6'b001111) begin  // load immediate value into the upper half-word of register rt
				alu_op = 4'b1000; // sll
				shamt_EX = 5'd16; // ?? -> what should this be
				enhilo_EX = 1'b0; // only for mult
				regsel_EX = 2'b00; // 0 for I-types indicating use lo register from alu as output, unless LW
				regwrite_EX = 1'b1; //1 if writing to a reg
				rdrt_EX = 1'b1; // rt destination
				memwrite_EX = 1'b1; // only 1 for lui to move bits to the highest 16 bits in dest register
				alu_src_EX = 2'b10; // default // set to 2 so that alu uses immediate val
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
			// addi, addiu
			end else if (i_type == 6'b001000 || i_type == 6'b001001) begin
				alu_op = 4'b0100;
				shamt_EX = 5'bXXXXX; // can alsodo 5'dX				
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; //0 for I-types, unless LW
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b1; // rt destination
				memwrite_EX = 1'b0; // don't need this anymore,  but we will keep it in
				alu_src_EX = 2'd1; // sign extend
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
			// andi
			end else if (i_type == 6'b001100) begin 
				alu_op = 4'b0000;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; //0 for I-types, unless LW
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b1; // rt destination
				memwrite_EX = 1'b0;
				alu_src_EX = 2'd2; // zero extend
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;

			// ori
			end else if (i_type == 6'b001101) begin 
				alu_op = 4'b0001;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; //0 for I-types, unless LW
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b1; // rt destination
				memwrite_EX = 1'b0;
				alu_src_EX = 2'd2; // zero extend
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
			// xori
			end else if (i_type == 6'b001110) begin 
				alu_op = 4'b0011;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; //0 for I-types, unless LW
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b1; // rt destination
				memwrite_EX = 1'b0;
				alu_src_EX = 2'd2;  // zero extend
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;	
			// slti
			end else if (i_type == 6'b001010) begin // all i-type codes are correct 
				alu_op = 4'b1100;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; //0 for I-types, unless LW
				regwrite_EX = 1'b1;
				rdrt_EX = 1'b1; // rt destination
				memwrite_EX = 1'b0;
				alu_src_EX = 2'd1;  // sign extend
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
			
			// bne
			/*
			end else if (i_type == 6'b000101) begin
				alu_op = 4'b0101; // sub
				if (~zero_EX) begin
					stall_FETCH = 1'b1;
					pc_src_EX = 2'b1;
				end
			*/			
			
			end else if (rst != 1'b0) begin // if reset = true
				alu_op = 4'bXXXX;
				shamt_EX = 5'bXXXXX;
				enhilo_EX = 1'b0;
				regsel_EX = 2'b00; //0 for I-types, unless LW
				regwrite_EX = 1'b0;
				rdrt_EX = 1'b0; // rt destination
				memwrite_EX = 1'b0;
				alu_src_EX = 2'd0;  // sign extend
				GPIO_OUT = 1'b0;
				GPIO_IN = 1'b0;
			end		
		end else begin
			alu_op = 4'bXXXX;
			shamt_EX = 5'bXXXXX;
			enhilo_EX = 1'bX;
			regsel_EX = 2'bXX; //0 for I-types, unless LW
			regwrite_EX = 1'b0;
			rdrt_EX = 1'bX; // rt destination
			memwrite_EX = 1'bX;
			alu_src_EX = 2'dX;  // sign extend
			GPIO_OUT = 1'bX;
			GPIO_IN = 1'bX;
		end
			
	end


endmodule
