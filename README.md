# mapf-project
Pruning project for MAPF

## Setup

+ We don't allow for:
	+ Vertex Conflicts
	+ Swap Conflicts

## Pruning Idea

+ We start by using the single agent shortest paths
	+ And throw away all verticies that aren't part of these plans
+ Then when combining these leads to a conflict we:
	1. Find the verticies where the conflict(s) occur
	2. Expand our selection of verticies to all cells reachabe by 1 from the conflict cells
	3. Try solving again ...

## Usage

We provided a python script which uses the clingo API to execute our pruning approach.

For provding the MIF input file and values for the `EXPANSION_HORIZON` as well as the `TIME_HORIZON` just modify the constants in lines `11-13` of the (solving.lp)[encoding/solving.lp] encoding file.

Then for executing our approach you can just run this on your command line.

```bash
python3 enconding/main.py
```

Necessary libraries are: 
+ clingo

These can be installed using pip:

```bash
pip install clingo
```

The output of our encoding is provided in asprilo format to aid easy visualization using the asprilo visualizer.

## Encoding

+ Actions: `occurs(object(robot,ID),action(move,(DX,DY)),TIMESTEP).`
+ Agent-Positions: `position(object(robot,ID),value(at,(X,Y)), TIMESTEP).`

# Benchmarks

## Benchmark Setup

+ CPU: `Intel i5 13600K`
+ RAM: `32GB DDR5`
+ GPU: `NVIDIA GeForce RTX 4070 Ti`
+ SYSTEM: `Ubuntu 23.04`
+ Timeout: `600 seconds`
+ Time Horizon: `40 time steps`


## Benchmark Results



| Instance                  | grid size | agents | Solving time (no pruning) in s | Solving time (with pruning) in s |
| ------------------------- | --------- | ------ | -------------------------: | ---------------------------: |
| test_s5_a1_smol           |$5\times5$| $01$       | -                      | $0.6711$                      |
| test_s5_a2_detour         |$5\times5$| $02$       | -                      | $66.5636$                        |
| test_s5_a2_exchange(hard) |$5\times5$| $02$       | -                      | $1.6703$                     |
| test_s5_a2_square         |$5\times5$| $02$       | -                      | $1.6369$                        |
| test_s4x2_a6_exchange     |$4\times2$| $06$       | -                      | $6.8939$                        |
| maze_s10_a25              |$10\times10$| $25$       | -                      | TIMEOUT                        |
| maze_s10_a30              |$10\times10$| $30$       | -                      | TIMEOUT                        |
| random_s10_a15_c50        |$10\times10$| $15$       | -                      | $47.1819$                        |
| random_s10_a20_c55        |$10\times10$| $20$       | -                      | $39.8370$                       |
| room_s10_a15_w1           |$10\times10$| $15$       | -                      | $52.3624$                        |
| room_s10_a30_w5           |$10\times10$| $30$       | -                      | $89.7547$                        |


The solving time of `test_s5_a2_detour` could probably also be reduced further, if instead of just solving when new nodes are expanded, it is ensured that all conflict nodes are expanded before calling the solver. This is due to the most time during the execution of our approach being spent by the solver. So by making sure that every conflict node is expanded we reduce the amount of solver calls and thus the total runtime. 

Our approach doesn't seem to perform well on maze instances. This is expected since expanding from a few conflict nodes throughout a maze is very time consuming, since the intrecate paths of the maze have to be followed. The above modification mentioned for the `test_s5_a2_detour` instance could proably also increase performance on these benchmarks drasticly.

# Errors

```
TypeError: arguments did not match any overloaded call:
  QRect(): too many arguments
  QRect(int, int, int, int): argument 1 has unexpected type 'float'
  QRect(QPoint, QPoint): argument 1 has unexpected type 'float'
  QRect(QPoint, QSize): argument 1 has unexpected type 'float'
  QRect(QRect): argument 1 has unexpected type 'float'
Aborted (core dumped)
```

+ Solved by using a *Python 3.9* venv
