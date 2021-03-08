# Stimulate_VHDL_via_named_Pipe
This is an example how to stimulate a VHDL Testbench via a named pipe. It requires VHDL 2008 because it uses the flush-Command which was added in this version.
The repository contains an example testbench "fileio.vhdl" and a related script to compile and simulate the file in ModelSim.
Further you will find a server program written in C for Windows. It opens one named pipe for sending stimulus data to the testbench and another named pipe to receive response data from the tesbench.
It was tested with the VHDL-testbench running with Modelsim with the GCC compiled server.
Have fun.
