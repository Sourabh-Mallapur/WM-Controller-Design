# WM-Controller-Design
 Washing Machine Controller Design in Verilog HDL

# Washing Machine Controller (WM-Controller)
This repository contains the Verilog implementation of a Washing Machine Controller module. This module is designed to control the different stages of a washing machine based on user input signals, such as lid, coin, and cancel with different modes for user to choose from.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Verilog Files](#verilog-files)
- [Simulation](#simulation)
- [State Diagram](#state-diagram)
- [Interpretting Code](#interpretting-code)

## Introduction

The Washing Machine Controller module is implemented in Verilog and uses a finite state machine to control the various stages of a washing machine.

## Features

- State machine implementation for washing machine control.
- Support for different modes with configurable soak, wash, rinse, and spin times.
- Outputs indicating the current state of the washing machine.

## Verilog Files

- `Controller.v`: Main Verilog file containing the Washing Machine Controller module.
- `testbench.v` : Testbench file.

## Simulation

To simulate the Verilog code, you can use a Verilog simulator such as Xilinx Vivado or Icarus Verilog or any online EDA Simulator.

### For Icarus Verilog

Add follwing code to testbench
```
initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #10000 $finish;
end
```

Commands to run Simulation using Gtkwave (on Windows)
```
> iverilog .\Controller.v .\testbench.v
> vvp.exe .\a.out
> gtkwave.exe .\dump.vcd
```

## State Diagram 
![alt text](https://github.com/Sourabh-Mallapur/WM-Controller-Design/blob/main/misc/FSM.drawio.png)


## Interpretting Code
| Signal name   |  Direction | Description |
| ------------- | ---------- | ----------- |
| clk |input| Clock signal |
| lid |input| Machine door (lid) is open |
| Coin |input| Start wash machine after coin insertion |
| Cancel |input| Cancels the washing process |
| mode |input| Select Washing modes |
| idle_op |output| Do not perform any process |
| ready_op |output| Machine is ready to start the process
| soak_op |output| Soaking operation |
| wash_op |output| Washing operation |
| rinse_op |output| Rinsing operation |
| spin_op |output| Spinning operation |
| coin_rtrn |output| Return the coin |
| water_inlet |output| Water intake |

## Synthesis using Cadence EDA Suite
Synthesis done in Cadence Genus Software 

### Requirements for Synthesis 
- `Controller.v`: Design file
- `saed90nm_typ.lib`: Technology file
- `constraints_wmc.sdc`: Constraints file

constraints_wmc.sdc
```# Creating Clock
set EXTCLK "clk" ;
set_units -time 1.0ns ;
set EXTCLK_PERIOD 20.0; #50MHz
create_clock -name "$EXTCLK" -period "$EXTCLK_PERIOD" -waveform "0
[expr $EXTCLK_PERIOD/2]" [get_ports clk]

# Setting Clock Skew
set SKEW 0.200 
set_clock_uncertainty $SKEW [get_clocks $EXTCLK]

# Setting Rise and Fall latency
set SRLATENCY 0.80
set SFLATENCY 0.75

# Setting Rise and Fall times
set MINRISE  0.20
set MAXRISE  0.25
set MINFALL  0.15
set MAXFALL  0.10

set_clock_transition -rise -min $MINRISE [get_clocks $EXTCLK]
set_clock_transition -rise -max $MAXRISE [get_clocks $EXTCLK]
set_clock_transition -fall -min $MINFALL [get_clocks $EXTCLK]
set_clock_transition -fall -max $MAXFALL [get_clocks $EXTCLK]

# Setting Input and Output Delays for ports
set INPUT_DELAY 0.5
set OUTPUT_DELAY 0.5

set_input_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports lid]
set_input_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports coin]
set_input_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports cancel]
set_input_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports mode]

set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports idle_op]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports ready_op]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports soak_op]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports wash_op]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports rinse_op]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports spin_op]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports coin_rtn]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports water_inlet]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports soak_done]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports wash_done]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports rinse_done]
set_output_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports spin_done]
```

```
genus -gui
read_libs <path of .lib file>
read_hdl <path of design file>
```
Opens Genus, reads the library file from the specified path which in this case is saed90nm_typ.lib
the 90 nanometer typical library.
Reads the Hdl Design file from the specified path.

```
elaborate
```
Elaborates the design in the tool, and can be viewed in the GUI by selecting
Hier Cell > Schematic View(Module) > in New.

### Adding contstrainsts
```
read_sdc <path of .sdc constraints file>
syn_generic
```
Synthesizes the design to the G Tech cells (default cells for the Cadence Tool)

```
syn_map
```
maps the synthesized cells to the library specified earlier in read_libs command

```
syn_opt -incremental
```
Incrementally optimizes the synthesized design

```
report_timing > (path for .rpt file to save timing report)
report_area > (path for .rpt file to save area report)
report_power > (path for .rpt file to save power report)
```
Reports timing Time Borrowed, Uncertainty, Required Time, Launch Clock, Data Path and Slack.
Reports area of the synthesized design in micro-meters-square
Reports power in nano Watts (nW)

```
write_hdl > (path for .v file for netlist to be written)
```
Writes the netlist in HDL format in the path specified

## Results/Reports from Synthesis

Area report - 
```
============================================================
  Generated by:           Genus(TM) Synthesis Solution 20.11-s111_1
  Generated on:           Dec 26 2023  12:06:52 pm
  Module:                 washing_machine_ctrl
  Operating conditions:   _nominal_ (balanced_tree)
  Wireload mode:          enclosed
  Area mode:              timing library
============================================================

      Instance       Module  Cell Count  Cell Area  Net Area   Total Area   Wireload  
--------------------------------------------------------------------------------------
washing_machine_ctrl                 14    137.318     0.000      137.318 <none> (D)  
  (D) = wireload is default in technology library
```

Power report - 
```
Instance: /washing_machine_ctrl
Power Unit: W
PDB Frames: /stim#0/frame#0
  --------------------------------------------------------------------------
    Category         Leakage      Internal    Switching        Total    Row%
  --------------------------------------------------------------------------
      memory     0.00000e+00   0.00000e+00  0.00000e+00  0.00000e+00   0.00%
    register     2.52486e-07  -2.74955e-07  1.47977e-07  1.25508e-07   7.57%
       latch     0.00000e+00   0.00000e+00  0.00000e+00  0.00000e+00   0.00%
       logic     3.65781e-07   6.75014e-07  2.97577e-07  1.33837e-06  80.71%
        bbox     0.00000e+00   0.00000e+00  0.00000e+00  0.00000e+00   0.00%
       clock     0.00000e+00   0.00000e+00  1.94400e-07  1.94400e-07  11.72%
         pad     0.00000e+00   0.00000e+00  0.00000e+00  0.00000e+00   0.00%
          pm     0.00000e+00   0.00000e+00  0.00000e+00  0.00000e+00   0.00%
  --------------------------------------------------------------------------
    Subtotal     6.18267e-07   4.00060e-07  6.39954e-07  1.65828e-06 100.00%
  Percentage          37.28%        24.12%       38.59%      100.00% 100.00%
  --------------------------------------------------------------------------
```

Timing report -
```
============================================================
  Generated by:           Genus(TM) Synthesis Solution 20.11-s111_1
  Generated on:           Dec 26 2023  12:06:23 pm
  Module:                 washing_machine_ctrl
  Operating conditions:   _nominal_ (balanced_tree)
  Wireload mode:          enclosed
  Area mode:              timing library
============================================================


Path 1: MET (19155 ps) Late External Delay Assertion at pin coin_rtn
          Group: clk
     Startpoint: (R) cancel
          Clock: (R) clk
       Endpoint: (R) coin_rtn
          Clock: (R) clk

                     Capture       Launch     
        Clock Edge:+   20000            0     
        Drv Adjust:+       0            0     
       Src Latency:+       0            0     
       Net Latency:+       0 (I)        0 (I) 
           Arrival:=   20000            0     
                                              
      Output Delay:-     300                  
       Uncertainty:-     200                  
     Required Time:=   19500                  
      Launch Clock:-       0                  
       Input Delay:-     300                  
         Data Path:-      45                  
             Slack:=   19155                  

Exceptions/Constraints:
  input_delay              300             constraints_wmc.sdc_line_34 
  output_delay             300             constraints_wmc.sdc_line_43 

#----------------------------------------------------------------------------------------
# Timing Point   Flags    Arc   Edge   Cell     Fanout Load Trans Delay Arrival Instance 
#                                                      (fF)  (ps)  (ps)   (ps)  Location 
#----------------------------------------------------------------------------------------
  cancel         -       -      R     (arrival)      3  7.8     0     0     300    (-,-) 
  g1022__8428/Q  -       IN2->Q R     AND2X1         1  0.0    24    45     345    (-,-) 
  coin_rtn       <<<     -      R     (port)         -    -     -     0     345    (-,-) 
#----------------------------------------------------------------------------------------

```
Netlist generated -

```

// Generated by Cadence Genus(TM) Synthesis Solution 20.11-s111_1
// Generated on: Dec 26 2023 12:08:19 IST (Dec 26 2023 06:38:19 UTC)

// Verification Directory fv/washing_machine_ctrl 

module washing_machine_ctrl(clk, lid, coin, cancel, mode, idle_op,
     ready_op, soak_op, wash_op, rinse_op, spin_op, coin_rtn,
     water_inlet, soak_done, wash_done, rinse_done, spin_done);
  input clk, lid, coin, cancel;
  input [1:0] mode;
  output idle_op, ready_op, soak_op, wash_op, rinse_op, spin_op,
       coin_rtn, water_inlet, soak_done, wash_done, rinse_done,
       spin_done;
  wire clk, lid, coin, cancel;
  wire [1:0] mode;
  wire idle_op, ready_op, soak_op, wash_op, rinse_op, spin_op,
       coin_rtn, water_inlet, soak_done, wash_done, rinse_done,
       spin_done;
  wire [2:0] r_reg;
  wire n_1, n_3, n_4, n_5, n_6, n_9, n_10, n_11;
  wire n_12;
  assign spin_done = 1'b0;
  assign rinse_done = 1'b0;
  assign wash_done = 1'b0;
  assign soak_done = 1'b0;
  assign water_inlet = soak_op;
  assign spin_op = 1'b0;
  assign rinse_op = 1'b0;
  DFFX1 \r_reg_reg[0] (.CLK (clk), .D (n_12), .Q (r_reg[0]), .QN (n_3));
  NOR3X0 g1017__2398(.IN1 (n_10), .IN2 (cancel), .IN3 (lid), .QN
       (n_12));
  DFFX1 \r_reg_reg[1] (.CLK (clk), .D (n_11), .Q (r_reg[1]), .QN (n_1));
  NOR3X0 g1018__5107(.IN1 (n_9), .IN2 (cancel), .IN3 (lid), .QN (n_11));
  OA22X1 g1019__6260(.IN1 (n_3), .IN2 (n_6), .IN3 (r_reg[1]), .IN4
       (n_4), .Q (n_10));
  AOI21X1 g1020__4319(.IN1 (r_reg[0]), .IN2 (n_5), .IN3 (r_reg[1]), .QN
       (n_9));
  AND2X1 g1022__8428(.IN1 (ready_op), .IN2 (cancel), .Q (coin_rtn));
  AND2X1 g1021__5526(.IN1 (n_1), .IN2 (n_5), .Q (n_6));
  NAND2X1 g1023__6783(.IN1 (n_3), .IN2 (coin), .QN (n_4));
  NOR2X0 g1024__3680(.IN1 (r_reg[1]), .IN2 (n_3), .QN (ready_op));
  NOR2X0 g1027__1617(.IN1 (n_1), .IN2 (n_3), .QN (wash_op));
  NOR2X0 g1025__2802(.IN1 (r_reg[0]), .IN2 (n_1), .QN (soak_op));
  NAND2X1 g1028__1705(.IN1 (mode[1]), .IN2 (mode[0]), .QN (n_5));
  NOR2X0 g1026__5122(.IN1 (r_reg[0]), .IN2 (r_reg[1]), .QN (idle_op));
endmodule

```

![alt text](https://github.com/Sourabh-Mallapur/WM-Controller-Design/blob/main/syn/syn_generic2.png)
![alt text](https://github.com/Sourabh-Mallapur/WM-Controller-Design/blob/main/syn/syn_map2.png)
![alt text](https://github.com/Sourabh-Mallapur/WM-Controller-Design/blob/main/syn/syn_opt.png)