from __future__ import annotations
from dataclasses import dataclass, field
from enum import Enum
from typing import Literal, NewType, TypedDict

PortDirection = Literal['input', 'output', 'inout']
Bit = NewType('Bit', int)

class CellDict(TypedDict):
    type: str
    parameters: dict[str, str]
    port_directions: dict[str, PortDirection]
    connections: dict[str, list[Bit]]

class PortDict(TypedDict):
    direction: PortDirection
    bits: list[Bit]

class PortDirections(Enum):
    INPUT = 'input'
    OUTPUT = 'output'
    INOUT = 'inout'

@dataclass
class StrPort:
    name: str
    bit: Bit
    of: str

@dataclass
class Port:
    name: str
    bit: Bit
    of: Cell

    def __repr__(self) -> str:
        return f'{self.of.name}.{self.name}[{self.bit}]'

@dataclass
class Cell:
    name: str
    type: str
    parameters: dict[str, int] = field(repr=False) # TODO: only int parameters supported
    port_directions: dict[str, PortDirections] = field(repr=False)
    str_connections: dict[str, list[StrPort]] = field(repr=False)
    connections: dict[str, list[Port]]

    def __init__(self, name: str, d: CellDict, bits: dict[Bit, StrPort]) -> None:
        self.name = name
        self.type = d['type']
        self.parameters = {name: int(value, 2)
                           for name, value in d['parameters'].items()}
        self.port_directions = {name: PortDirections(value)
                                for name, value in d['port_directions'].items()}
        self.str_connections = {name: [bits[bit] for bit in value]
                            for name, value in d['connections'].items()}
        self.connections = {}

    def fill_connections(self, cells: dict[str, Cell]) -> None:
        self.connections.update({
            name: [Port(port.name, port.bit, cells[port.of])
                   for port in ports]
            for name, ports in self.str_connections.items()
        })

def _gather_bits(module: str, cell_dicts: dict[str, CellDict], port_dicts: dict[str, PortDict]) -> dict[Bit, StrPort]:
    bits: dict[Bit, StrPort] = {}
    for port_name, port_dict in port_dicts.items():
        for bit in port_dict['bits']:
            if port_dict['direction'] != 'input':
                continue
            bits[bit] = StrPort(port_name, bit, module)
    for cell_name, cell_dict in cell_dicts.items():
        for port_name, port in cell_dict['connections'].items():
            if cell_dict['port_directions'][port_name] != 'input':
                continue
            for bit in port:
                bits[bit] = StrPort(port_name, bit, cell_name)
    return bits

def gather_cells(
    module: str,
    cell_dicts: dict[str, CellDict],
    port_dicts: dict[str, PortDict]
) -> dict[str, Cell]:
    bits = _gather_bits(module, cell_dicts, port_dicts)
    cells: dict[str, Cell] = {name: Cell(name, d, bits) for name, d in cell_dicts.items()}
    cells[module] = Cell(module, {
        'type': module,
        'parameters': {},
        'port_directions': {name: port_dict['direction'] for name, port_dict in port_dicts.items()},
        'connections': {name: port_dict['bits'] for name, port_dict in port_dicts.items()}
    }, bits)
    for cell in cells.values():
        cell.fill_connections(cells)
    return cells
