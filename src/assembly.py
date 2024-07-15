#!/usr/bin/env python3
from collections.abc import Iterator
from typing import cast
from nbt_structure_utils import Cuboid, NBTStructure, Vector

def clone_clamp(struct: NBTStructure, name: str, width: int) -> NBTStructure:
    loaded = NBTStructure(name)
    max_coords = loaded.get_max_coords()
    max_coords.z = width - 1
    volume = cast(Iterator[Vector], Cuboid(Vector(0, 0, 0), max_coords))
    struct.clone_structure(loaded, Vector(0, 0, 0), volume)
    return struct

def MC_DFF31(WIDTH: int) -> NBTStructure:
    width = WIDTH * 2 + 1 # 2 blocks per bit + 2 blocks per clk - 1
    return clone_clamp(NBTStructure(), 'structures/mc_dff31.nbt', width)

def MC_ADFF31(WIDTH: int, ARST_VALUE: int) -> NBTStructure:
    # load structures
    a0dff1_cell = NBTStructure('structures/mc_a0dff1_cell.nbt')
    a1dff1_cell = NBTStructure('structures/mc_a1dff1_cell.nbt')
    # assemble structures together
    width = WIDTH * 2 + 3 # 2 blocks per bit + 2 blocks per (clk, arst) - 1
    struct = clone_clamp(NBTStructure(), 'structures/mc_adff_input.nbt', width)
    input_max_coords = struct.get_max_coords()
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
