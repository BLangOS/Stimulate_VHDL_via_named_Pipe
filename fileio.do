# ------------------------------------------------------------------------------------------------
# B. Lang, OS
# ------------------------------------------------------------------------------------------------

vcom -work work fileio.vhdl

vsim work.example_file_io_tb(behave)

add wave /example_file_io_tb/clock
add wave /example_file_io_tb/result
add wave /example_file_io_tb/result_sync
add wave /example_file_io_tb/stimulus

# bp fileio.vhdl 65

run 400 ns
