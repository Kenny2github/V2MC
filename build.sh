#!/bin/bash

if [ $# -lt 2 ]; then
	echo "usage: $0 <top module> <verilog files...>" >&2
	exit 1
fi

TOP=$1
shift

mkdir -p build show

echo "read_verilog -sv $*" > tmp.ys
echo "hierarchy -check -top $TOP" >> tmp.ys
cat v2mc.ys >> tmp.ys
yosys -s tmp.ys
rm tmp.ys
