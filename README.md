# Verilog to Minecraft Redstone
This project provides Minecraft redstone as a synthesis target for Verilog

## Goal
Fully synthesize all [Yosys internal gates](https://yosyshq.readthedocs.io/projects/yosys/en/latest/CHAPTER_CellLib.html#gates) in Minecraft redstone. This includes both combinational and sequential logic - flip-flops and all that jazz.

This project is purely for placement, fitting, routing, or some combination thereof. The compilation of Verilog to basic gates is done by Yosys.

## Dependencies
The following must be in your `PATH`:
* Python 3
* Yosys 0.9, if you wish to give Verilog HDL design files as input.

## I/O Format
For input, we take either of the following:
* One or more Verilog HDL design files. These are passed to Yosys to produce:
* The `json`/`write_json` output of a Yosys `techmap` pass. The cells produced must all be either [Yosys internal gates](https://yosyshq.readthedocs.io/projects/yosys/en/latest/CHAPTER_CellLib.html#gates) or modules that expand to them.

For output, we produce a Minecraft structure file.
