# -- an example to run SPEC 429.mcf on gem5, put it under 429.mcf folder --
export GEM5_DIR=/usr/local/gem5
export BENCHMARK=./src/benchmark
export ARGUMENT=./data/inp.in

export I=10

for cpu in $(cat ~/conf/cpuModels); do
	for size in 16 32 64 128 256; do
		for bond in 2 4 8; do
			for l1s in '32kB' '64kB' '128kB' '256kB' '512kB'; do
				for l2s in '1MB' '2MB' '4MB'; do
					(time $GEM5_DIR/build/X86/gem5.opt -d ~/m5out $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT \
					-I $I --cpu-type=$cpu --caches --l2cache --l1d_size=$l1s --l1i_size=$l1s --l2_size=$l2s \
					--l1d_assoc=$bond --l1i_assoc=$bond --l2_assoc=1 --cacheline_size=$size) 1>~/results/out/L2-$cpu-$size-$bond-$l1s-$l2s-res 2>~/results/err/L2-$cpu-$size-$bond-$l1s-$l2s-res
				done
			done
		done
	done
done

for cpu in $(cat ~/conf/cpuModels); do
	for size in 16 32 64 128 256; do
		for bond in 2 4 8; do
			for l1s in '32kB' '64kB' '128kB' '256kB' '512kB'; do
					(time $GEM5_DIR/build/X86/gem5.opt -d ~/m5out $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT \
					-I $I --cpu-type=$cpu --caches --l1cache --l1d_size=$l1s --l1i_size=$l1s \
					--l1d_assoc=$bond --l1i_assoc=$bond --cacheline_size=$size) 1>~/results/out/L1-$cpu-$size-$bond-$l1s-res 2>~/results/err/L1-$cpu-$size-$bond-$l1s-res
			done
		done
	done
done

for cpu in $(cat ~/conf/cpuModels); do
					(time $GEM5_DIR/build/X86/gem5.opt -d ~/m5out $GEM5_DIR/configs/example/se.py -c $BENCHMARK -o $ARGUMENT \
					-I $I --cpu-type=$cpu) 1>~/results/out/L0-$cpu-res 2>~/results/err/L0-$cpu-res
done


#RESULT FILE NAME FORMAT1 - L2-CPU-BLOCKSIZE-ASSOCIATIVITY-L1SIZE-L2SIZE-res
#RESULT FILE NAME FORMAT1 - L1-CPU-BLOCKSIZE-ASSOCIATIVITY-L1SIZE--res
#RESULT FILE NAME FORMAT1 - L0-CPU-res