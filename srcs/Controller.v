`timescale 1ns / 1ps
module washing_machine_ctrl
(
    input clk,
    input wire lid, coin, cancel,
    input wire [1:0] mode,
    output wire idle_op, ready_op, soak_op, wash_op, rinse_op, spin_op,
    output wire coin_rtn, water_inlet, 
    output reg soak_done, wash_done, rinse_done, spin_done
);

localparam[1:0]
    MODE1 = 0,
    MODE2 = 1,
    MODE3 = 2,
    NOSEL = 4;
        
reg [2:0] wash_Counter, rinse_Counter, spin_Counter, soak_Counter;

    parameter IDLE = 3'd0 ;
    parameter READY = 3'd1;
    parameter SOAK = 3'd2;
    parameter WASH = 3'd3;
    parameter RINSE = 3'd4;
    parameter SPIN = 3'd5;
    
    integer SOAK_TIME;
    integer WASH_TIME;
    integer RINSE_TIME;
    integer SPIN_TIME;
	
	/* mode1
       Soak  : 1 mins
       Wash  : 2 mins
       Rinse : 2 mins
       Spin  : 2 mins   
	   
	   mode2 
       Soak  : 2 mins
       Wash  : 3 mins
       Rinse : 3 mins
       Spin  : 3 mins   
	   
	   mode3 
       Soak  : 3 mins
       Wash  : 5 mins
       Rinse : 5 mins
       Spin  : 5 mins   */
    
// signal declaration
reg [2:0] r_reg = 0, r_next;
    
always @(posedge clk)
    begin
        r_reg = r_next;
    end

always @ (negedge clk) begin 
    if (r_reg == IDLE || r_reg == READY) begin
        wash_Counter = 0;
        rinse_Counter = 0;
        spin_Counter = 0;
        soak_Counter = 0;
        wash_done = 0;
        rinse_done = 0;
        spin_done = 0; 
        soak_done = 0;
    end 

    case (r_reg)    
        SOAK:        
            soak_Counter = soak_Counter + 1'd1;            
        WASH: 
            wash_Counter = wash_Counter + 1'd1;               
        RINSE: 
            rinse_Counter = rinse_Counter + 1'd1;         
        SPIN: 
            spin_Counter = spin_Counter + 1'd1;               
    endcase
end

// mode logic 
always @(r_reg) 
    if (r_next == READY)
        case(mode)
            MODE1:  begin
                SOAK_TIME = 1;
                WASH_TIME = 2;
                RINSE_TIME = 2;
                SPIN_TIME = 2;
            end
            
            MODE2: begin
                SOAK_TIME = 2;
                WASH_TIME = 3;
                RINSE_TIME = 3;
                SPIN_TIME = 3;
            end
            
            MODE3: begin
                SOAK_TIME = 3;
                WASH_TIME = 5;
                RINSE_TIME = 5;
                SPIN_TIME = 5;
            end
        endcase
            

// next-state logic
always @*
begin
    if (lid == 1 || cancel == 1)
        r_next  <= IDLE;
    case(r_reg)
    IDLE:
        if(lid == 0 && coin == 1 && cancel == 0)
            r_next <= READY;
    
    READY:
        if(mode == 2'b00 || mode == 2'b01 || mode == 2'b10)
            if (lid == 0 && cancel == 0)
                r_next <= SOAK;
         else
             r_next <= READY;

    SOAK:   begin
        if (soak_Counter == SOAK_TIME)
            soak_done <= 1;
        if (lid == 0 && cancel == 0)
            if(soak_done)
                r_next <= WASH;
        else
            r_next <= SOAK;
      end
         
    WASH:   begin
        if (wash_Counter == WASH_TIME)
            wash_done <= 1;
        if(lid == 0 && cancel == 0)
            if(wash_done)
                r_next <= RINSE;
        else
            r_next <= WASH;
      end
            
    RINSE:  begin
        if (rinse_Counter >= RINSE_TIME)
            rinse_done <= 1;
        if (lid == 0 && cancel == 0)
            if(rinse_done)
                r_next <= SPIN;
        else
            r_next <= RINSE;
      end
      
    SPIN:   begin
        if (spin_Counter == SPIN_TIME)
            spin_done <= 1;   
        if (lid == 0 && cancel == 0)
            if(spin_done)
                r_next <= IDLE;
        else
            r_next <= SPIN;
      end
            
    default: r_next <= IDLE;
    
    endcase

end

//output logic
assign idle_op = (r_reg == IDLE);
assign ready_op = (r_reg ==READY);
assign soak_op = (r_reg == SOAK);
assign wash_op = (r_reg == WASH);
assign rinse_op = (r_reg == RINSE);
assign spin_op = (r_reg == SPIN);
assign coin_rtn = (r_reg == READY) && (cancel == 1);
assign water_inlet = (r_reg == SOAK) || (r_reg == RINSE);

endmodule