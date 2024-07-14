#!/bin/python3
from collections.abc import Iterator
from typing import cast
from nbt_structure_utils import Cuboid, NBTStructure, Vector

def MC_DFF31(WIDTH: int) -> NBTStructure:
    # load structures
    struct = NBTStructure()
    dff = NBTStructure('structures/mc_dff31.nbt')
    # cut off excess inputs
    width = WIDTH * 2 + 1 # 2 blocks per bit + 2 blocks per clk - 1
    input_max_coords = dff.get_max_coords()
    input_max_coords.z = width - 1
    volume = cast(Iterator[Vector], Cuboid(Vector(0, 0, 0), input_max_coords))
    # assemble structure
    struct.clone_structure(dff, Vector(0, 0, 0), volume)
    return struct

def MC_ADFF31(WIDTH: int, ARST_VALUE: int) -> NBTStructure:
    # load structures
    struct = NBTStructure()
    a0dff1_cell = NBTStructure('structures/mc_a0dff1_cell.nbt')
    a1dff1_cell = NBTStructure('structures/mc_a1dff1_cell.nbt')
    adff_input = NBTStructure('structures/mc_adff_input.nbt')
    # cut off excess inputs
    width = WIDTH * 2 + 3 # 2 blocks per bit + 2 blocks per (clk, arst) - 1
    input_max_coords = adff_input.get_max_coords()
    input_max_coords.z = width - 1
    volume = cast(Iterator[Vector], Cuboid(Vector(0, 0, 0), input_max_coords))
    # assemble structures together
    struct.clone_structure(adff_input, Vector(0, 0, 0), volume)
    for z in range(WIDTH):
        bit = WIDTH - 1 - z
        struct.clone_structure(
            a1dff1_cell if ARST_VALUE & (1 << bit) else a0dff1_cell,
            Vector(input_max_coords.x + 1, 0, z)
        )
    return struct

if __name__ == '__main__':
    module = input('Module: ').upper()
    if module == 'MC_DFF31':
        width = int(input('WIDTH = '))
        struct = MC_DFF31(width)
        struct.get_nbt().write_file(f'structures/mc_dff{width}_out.nbt')
    elif module == 'MC_ADFF31':
        width = int(input('WIDTH = '))
        arst_value = int(input('ARST_VALUE = '), 0)
        struct = MC_ADFF31(width, arst_value)
        arst_value = format(arst_value, f'0{width}b')
        struct.get_nbt().write_file(f'structures/mc_a{arst_value}dff{width}_out.nbt')
