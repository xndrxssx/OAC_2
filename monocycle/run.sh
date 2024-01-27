cd /home/runner
export PATH=/usr/bin:/bin:/tool/pandora64/bin:/usr/share/Riviera-PRO/bin
export RIVIERA_HOME=/usr/share/Riviera-PRO
export CPLUS_INCLUDE_PATH=/usr/share/Riviera-PRO/interfaces/include
export ALDEC_LICENSE_FILE=27009@10.116.0.5
export HOME=/home/runner
vlib work && vcom '-2019' '-o' adder32.vhd alu.vhd alucontrol.vhd control.vhd decode.vhd execute.vhd fetch.vhd memoryAccess.vhd mux25.vhd mux232.vhd registers.vhd rom.vhd rreg32.vhd writeback.vhd ram.vhd mux35.vhd mux332.vhd design.vhd testbench.vhd  && vsim -c -do "vsim testbench; run -all; exit"  ; echo 'Creating result.zip...' && zip -r /tmp/tmp_zip_file_123play.zip . && mv /tmp/tmp_zip_file_123play.zip result.zip