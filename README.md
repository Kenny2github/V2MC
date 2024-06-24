# Verilog to Minecraft Redstone
This project provides Minecraft redstone as a synthesis target for Verilog

## Goal
Fully synthesize all synthesizable Verilog. This includes both combinational and sequential logic - flip-flops and all that jazz.

This project is purely for technology mapping, placement, routing, or some combination thereof. Analysis & elaboration of Verilog is done by Yosys, and technology mapping is done with Yosys.

## Dependencies
The following must be in your `PATH`:
* Python 3
* Yosys 0.42

## I/O Format
For input, we take one or more Verilog HDL design files. For output, we produce a Minecraft structure file.

## Technology mapping
Currently we map the following [Yosys internal cells](https://yosyshq.readthedocs.io/projects/yosys/en/latest/yosys_internals/formats/cell_library.html#rtl-cells) to custom primitives:
* `$dff, $sdff, $sdffe` → `MC_DFF29`
* `$adff, $adffe` → `MC_ADFF29`

Redstone signal strength is the main factor leading to the limitation of `WIDTH` to 29 (15 signal strength, in two directions) when any input/output is a number of bits independent of `WIDTH`. The technology mapping process reduces, for example, a 64-bit `$dff` to two 29-bit and one 6-bit `MC_DFF29`s.

All others we allow `techmap` to map to [Yosys internal gates](https://yosyshq.readthedocs.io/projects/yosys/en/latest/yosys_internals/formats/cell_library.html#gates), which we then map to custom primitives:
