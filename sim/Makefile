VERILATOR = verilator
VFLAGS = --binary --timing --trace -Wno-TIMESCALEMOD --top top_tb -f filelist.f

# Default target builds and runs the simulation
all: run

# Run Verilator to generate the C++ model and compile it
compile:
	$(VERILATOR) $(VFLAGS)

# Execute the compiled simulation
run: compile
	./obj_dir/Vtop_tb

# Delete generated files to keep the directory clean
clean:
	rm -rf obj_dir wave.vcd