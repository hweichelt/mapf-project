from time import perf_counter
from typing import List, Tuple, Optional, Union
from pathlib import Path

import clingo


SCRIPT_PATH = Path(__file__).parent

# USER INPUT
MIF_INSTANCE = SCRIPT_PATH.joinpath("../resources/Instances/maze_s10_a30.lp")
EXPANSION_HORIZON = 20
TIME_HORIZON = 40

MIF_ASPRILO_CONVERTER_PATH = SCRIPT_PATH.joinpath("convert_mif/mif_to_asprilo.lp")
CONFLICT_FINDER_PATH = SCRIPT_PATH.joinpath("conflict_check/check_conflicts.lp")
PRUNING_ENCODING_PATH = SCRIPT_PATH.joinpath("pruning/pruning.lp")
MAPF_SOLVER_PATH = SCRIPT_PATH.joinpath("solver.lp")


def mif_to_asprilo(program_string: str) -> str:
    mif_to_asprilo_program = read_file(MIF_ASPRILO_CONVERTER_PATH)
    asprilo_result = solve(
        [mif_to_asprilo_program, program_string],
        [("occurs", 3), ("init", 2)]
    )
    output_string = ".\n".join([str(s) for s in asprilo_result])
    if output_string:
        output_string += "."

    return output_string


def read_file(path: Union[Path, str]) -> str:
    with open(path, "r") as f:
        return f.read()


def solve(
        program_strings: List[str],
        output_signatures: Optional[List[Tuple[str, int]]] = None
) -> Optional[List[clingo.Symbol]]:
    ctl = clingo.Control()
    for p in program_strings:
        ctl.add("base", [], p)
    ctl.ground([("base", [])])
    result = ctl.solve(yield_=True)
    if result.get().satisfiable:
        model = result.model().symbols(atoms=True, shown=True)
        if output_signatures is not None:
            model = [s for s in model if any(s.match(*sig) for sig in output_signatures)]
    else:
        model = None
    return model


def parse_asp_program(symbol_list: List[clingo.Symbol]) -> str:
    out = ".\n".join([str(s) for s in symbol_list])
    out = out + "." if out else out
    return out


def solve_mapf_with_conflict_pruning(mif_instance_string: str, verbose: int = 0) -> Optional[List[clingo.Symbol]]:
    # convert mif_encoding to asprilo
    asprilo_instance = mif_to_asprilo(mif_instance_string)
    if verbose > 1:
        print("ASPRILO INSTANCE:", asprilo_instance)

    # read program encoding contents
    conflict_finder_program = read_file(CONFLICT_FINDER_PATH)
    pruning_program = read_file(PRUNING_ENCODING_PATH)
    mapf_solver = read_file(MAPF_SOLVER_PATH)

    # compute the single agents path nodes
    single_agen_path_nodes = solve(
        ["#const expansion_depth=0.", asprilo_instance, pruning_program],
        [('expanded_node', 2)]
    )
    single_agen_path_nodes_string = parse_asp_program(single_agen_path_nodes)

    # find initial conflicts from single agent plans
    conflicts = solve(
        [asprilo_instance, conflict_finder_program],
        [('conflict_node', 1)]
    )

    # if there are no conflicts just return the single agent paths without solving
    if not conflicts:
        if verbose > 0:
            print("NO CONFLICTS FOUND -> NO EXPANSION")
        solution = solve(
            [
                mapf_solver,
                asprilo_instance,
                single_agen_path_nodes_string,
                f"#const upper_bound={TIME_HORIZON}."
            ],
            [('occurs_final', 3)]
        )
        return solution

    conflicts_string = parse_asp_program(conflicts)
    if verbose > 0:
        print("CONFLICTS:", [str(s) for s in conflicts])

    print(conflicts_string)

    # setup for loop with nodes from the single agent plans
    last_nodes = single_agen_path_nodes
    expansion_depth = 0
    while True:
        expansion_depth += 1
        # increase expansion_depth until horizon is reached
        if verbose > 0:
            print("+ EXPANSION_DEPT:", expansion_depth)
        if expansion_depth >= EXPANSION_HORIZON:
            break

        # solve to get single agent plan node set with expanded nodes of depth expansion_depth from conflict nodes
        expanded_nodes = solve(
            [f"#const expansion_depth={expansion_depth}.", asprilo_instance, conflicts_string, pruning_program],
            [('expanded_node', 2)]
        )
        if expanded_nodes == last_nodes:
            if verbose > 0:
                print("-> No change to single agent paths detected:", expansion_depth)
            continue

        if verbose > 0:
            print("- Found new nodes:", [str(s) for s in expanded_nodes if s not in last_nodes])

        # try solving with new further expanded node set
        expanded_nodes_string = parse_asp_program(expanded_nodes)
        solution = solve(
            [
                mapf_solver,
                asprilo_instance,
                expanded_nodes_string,
                f"#const upper_bound={TIME_HORIZON}."
            ],
            [('occurs_final', 3)]
        )

        # updating last_nodes to keep track of coming changes
        last_nodes = expanded_nodes

        # if solution is found return
        if solution is not None:
            if verbose > 0:
                print("FOUND SOLUTION:", [str(s) for s in solution])
            return solution

    return None


if __name__ == "__main__":
    mif_instance = read_file(MIF_INSTANCE)

    start_t = perf_counter()
    mapf_solution = solve_mapf_with_conflict_pruning(mif_instance, verbose=1)
    end_t = perf_counter()

    print("SOLUTION:", ". ".join([str(s) for s in mapf_solution]).replace("occurs_final", "occurs") + ".")
    print("TIME:", "%.4f" % (end_t - start_t), "s")
