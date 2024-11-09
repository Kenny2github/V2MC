from __future__ import annotations
from dataclasses import dataclass, field
from typing import Union, cast

from pyosys.libyosys import Cell, IdString, Module, SigSpec, Wire

@dataclass
class Node:
    driver: Union[Wire, Cell]
    neighbors: set[Node] = field(default_factory=set)
    input: bool = False

    def __hash__(self) -> int:
        return hash(self.driver.name)

def sigspec_to_wire(sig: SigSpec) -> Wire:
    if sig.is_wire():
        return sig.as_wire()
    elif sig.is_chunk() and sig.as_chunk().is_wire():
        return sig.as_chunk().wire
    elif sig.is_bit() and sig.as_bit().is_wire():
        return sig.as_bit().wire
    else:
        raise ValueError(f'{sig!r} is not a wire in any capacity')

def cell_graph(module: Module) -> list[Node]: # list of input nodes
    nodes = {name.str(): Node(cell) for name, cell in module.cells_.items()} \
        | {name.str(): Node(wire) for name, wire in module.wires_.items()
           if wire.port_input or wire.port_output}
    for node in nodes.values():
        if not hasattr(node.driver, 'connections'):
            continue
        cell = cast(Cell, node.driver)
        for name, spec in cell.connections().items():
            wire = sigspec_to_wire(spec)
            if wire.port_id:
                if wire.port_input:
                    node.input = True
                driver = wire
            else:
                driver = wire.driverCell()
            other = nodes[driver.name.str()]
            node.neighbors.add(other)
            other.neighbors.add(node)
    return [node for node in nodes.values() if node.input]
