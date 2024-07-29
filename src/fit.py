from collections import deque
import json
from typing import Optional

from yosys_techmap import Bit, Cell, CellDict, PortDict, PortDirections, gather_cells

def place(techmap: str, module: str) -> list[list[Cell]]:
    """Perform preliminary placement of cells in a module.

    Parameters:
        techmap: JSON file containing Yosys technology mapper output.
        module: Name of top level module to place.

    Returns:
        Structure containing placed cells.
    """
    with open(techmap, 'rb') as f:
        mod = json.load(f)['modules'][module]
        cell_dicts: dict[str, CellDict] = mod['cells']
        port_dicts: dict[str, PortDict] = mod['ports']
    cells = gather_cells(module, cell_dicts, port_dicts)
    q = deque[Optional[Cell]]()
    q.append(cells[module])
    q.append(None)
    rows: list[list[Cell]] = [[]]
    seen: set[Bit] = set()
    while q:
        cell = q.popleft()
        if cell is None:
            if q:
                q.append(None)
                rows.append([])
            continue
        for name, ports in cell.connections.items():
            for port in ports:
                if cell.port_directions[name] == PortDirections.INPUT:
                    continue
                if port.bit in seen:
                    continue
                seen.add(port.bit)
                q.append(port.of)
        rows[-1].append(cell)
    return rows[:-1]

if __name__ == '__main__':
    path = input('Path: ')
    module = input('Module: ')
    from pprint import pprint
    placement = place(path, module)
    try:
        pprint(placement)
        print(list(map(len, placement)))
    except BrokenPipeError:
        pass # `more`/`less` quit
