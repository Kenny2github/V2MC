#!/usr/bin/env python3
import os
from pathlib import Path
import re
from collections.abc import Iterator
from typing import cast
from nbt_structure_utils import Cuboid, NBTStructure, Vector

STRUCTS: dict[str, NBTStructure] = {}

def get_struct_ref(name: str) -> NBTStructure:
    """Get a reference to a structure loaded from disk.
    The structure is only loaded from disk once.

    Do not modify this reference. If you need a modifiable copy of this
    reference, use get_struct().

    Parameters:
        name: The MC_* name of the structure to get.

    Returns:
        The named structure.
    """
    if name not in STRUCTS:
        STRUCTS[name] = NBTStructure(str(Path('structures', name.lower() + '.nbt')))
    return STRUCTS[name]

def get_struct(name: str) -> NBTStructure:
    """Get a copy of a structure loaded from disk.
    The structure is only loaded from disk once.

    Parameters:
        name: The MC_* name of the structure to get.

    Returns:
        A copy of the named structure.
    """
    return get_struct_ref(name).copy()

def clone_clamp(struct: NBTStructure, name: str, width: int) -> NBTStructure:
    """Truncate the named structure to z=width and clone it into struct.

    Parameters:
        struct: The structure to clone into.
        name: The MC_* name of the structure to clone from.
        width: The width in the z-axis to clamp to.

    Returns:
        The given struct, with modifications.
    """
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

def MC_UAND16(WIDTH: int) -> NBTStructure:
    width = max(2, WIDTH * 2 - 1) # 2 blocks per bit - 1, but 1 bit needs 2
    return clone_clamp(NBTStructure(), 'structures/mc_uand16.nbt', width)

def MC_UNOR16(WIDTH: int) -> NBTStructure:
    width = WIDTH * 2 - 1 # 2 blocks per bit - 1
    return clone_clamp(NBTStructure(), 'structures/mc_unor16.nbt', width)

def MC_UOR16(WIDTH: int) -> NBTStructure:
    width = WIDTH * 2 - 1 # 2 blocks per bit - 1
    return clone_clamp(NBTStructure(), 'structures/mc_uor16.nbt', width)

def MC_XOR() -> NBTStructure:
    return NBTStructure('structures/mc_xor.nbt')

def MC_UXOR4(WIDTH: int) -> NBTStructure:
    width = WIDTH * 2 - 1 # 2 blocks per bit - 1
    return clone_clamp(NBTStructure(), 'structures/mc_uxor4.nbt', width)

def MC_UXOR8(WIDTH: int) -> NBTStructure:
    width = WIDTH * 2 - 1 # 2 blocks per bit - 1
    return clone_clamp(NBTStructure(), 'structures/mc_uxor8.nbt', width)

def MC_UXOR16(WIDTH: int) -> NBTStructure:
    width = WIDTH * 2 - 1 # 2 blocks per bit - 1
    return clone_clamp(NBTStructure(), 'structures/mc_uxor16.nbt', width)

if __name__ == '__main__':
    module = input('Module: ').upper()
    if module == 'MC_ADFF31':
        width = int(input('WIDTH = '))
        arst_value = int(input('ARST_VALUE = '), 0)
        struct = MC_ADFF31(width, arst_value)
        arst_value = format(arst_value, f'0{width}b')
        struct.get_nbt().write_file(f'structures/mc_a{arst_value}dff{width}_out.nbt')
    elif module in set(
        'MC_DFF31 MC_UAND16 MC_UNOR16 MC_UOR16 '
        'MC_UXOR4 MC_UXOR8 MC_UXOR16'.split()
    ):
        width = int(input('WIDTH = '))
        struct: NBTStructure = globals()[module](width)
        name = re.sub(r'\d+$', '', module.lower())
        struct.get_nbt().write_file(f'structures/{name}{width}_out.nbt')
    elif module in set(
        'MC_XOR'.split()
    ):
        struct: NBTStructure = globals()[module]()
        struct.get_nbt().write_file(f'structures/{module.lower()}_out.nbt')
