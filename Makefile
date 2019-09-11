# Makefile for RIPE
# @author John Wilander & Nick Nikiforakis
# Modified for RISC-V by John Merrill

#Depending on how you test your system you may want to comment, or uncomment
#the following
CFLAGS = -fno-stack-protector -z execstack
CC     = riscv64-unknown-elf-gcc
CLANG  = /home/zhixingx/riscv/_install/bin/clang
LLC    = /home/zhixingx/riscv/_install/bin/llc
OPT    = /home/zhixingx/riscv/_install/bin/opt
TAINT  = "/home/zhixingx/Taint_Analysis/build/libTaintAnalysis.so"

all: ripe_attack_generator_tag

clean:
	rm -rf build/ out/

ripe_attack_generator_tag: ./source/ripe_attack_generator.c
	mkdir -p build/ out/
	$(CLANG) -O0 -emit-llvm \
		./source/ripe_attack_generator.c -S -o ./build/ripe_attack_generator.ll
	$(OPT) -O0 -instnamer \
		./build/ripe_attack_generator.ll -S -o ./build/ripe_attack_generator.ll
	$(OPT) -load $(TAINT) -taint-analysis \
		./build/ripe_attack_generator.ll -S -o ./build/ripe_attack_generator.ll
	$(LLC) -O0 -march=riscv64 \
		./build/ripe_attack_generator.ll -o ./build/ripe_attack_generator.s
	$(CC) \
		./build/ripe_attack_generator.s -O0 -lm -o ./build/ripe_attack_generator

ripe_attack_generator: ./source/ripe_attack_generator.c
	mkdir -p build/ out/
	$(CC) \
		./source/ripe_attack_generator.c -o ./build/ripe_attack_generator
