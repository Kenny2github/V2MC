from collections import deque
from typing import Optional

from pyosys.libyosys import Design, IdString, escape_id, run_pass

from yosys_techmap import Node, cell_graph

def place(techmap: str, module: str) -> list[list[Node]]:
    """Perform preliminary placement of cells in a module.

    Parameters:
        techmap: JSON file containing Yosys technology mapper output.
        module: Name of top level module to place.

    Returns:
        Structure containing placed cells.
    """
    design = Design()
    run_pass(f'read_rtlil {techmap}', design)
    mod = design.module(IdString(escape_id(module)))

    origins = cell_graph(mod)

    q = deque[Optional[Node]]()
    seen: set[Node] = set()
    rows: list[list[Node]] = [[]]
    for node in origins:
        q.append(node)
    q.append(None)

    while q:
        node = q.popleft()
        if node is None:
            if q:
                q.append(None)
                rows.append([])
            continue
        rows[-1].append(node)
        seen.add(node)
        for neighbor in node.neighbors:
            if neighbor in seen:
                continue
            q.append(node)
    return rows

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
