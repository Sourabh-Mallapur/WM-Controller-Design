# Creating Clock
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

# set_input_delay -clock [get_clocks $EXTCLK] -add_delay 0.3 [get_ports clk]
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
