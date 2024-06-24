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
