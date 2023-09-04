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



| Instance                  | grid size | agents | Solving time (no pruning) in s |           Solving time (with pruning) in s |
| ------------------------- | --------- | ------ |-------------------------------:|-------------------------------------------:|
| test_s5_a1_smol           |$5\times5$| $01$       |                        $0.190$ |                                   $0.6711$ |
| test_s5_a2_detour         |$5\times5$| $02$       |                        $0.548$ |                                  $66.5636$ |
| test_s5_a2_exchange(hard) |$5\times5$| $02$       |                        $0.548$ |                                   $1.6703$ |
| test_s5_a2_square         |$5\times5$| $02$       |                        $0.566$ |                                   $1.6369$ |
| test_s4x2_a6_exchange     |$4\times2$| $06$       |                        $2.734$ |                                   $6.8939$ |
| maze_s10_a25              |$10\times10$| $25$       |    						UNSAT  |           						 TIMEOUT  |
| maze_s10_a30              |$10\times10$| $30$       |    						UNSAT  |           					 	 TIMEOUT  |
| random_s10_a15_c50        |$10\times10$| $15$       |                       $14.177$ |                                  $47.1819$ |
| random_s10_a20_c55        |$10\times10$| $20$       |                       $41.690$ |                                  $39.8370$ |
| room_s10_a15_w1           |$10\times10$| $15$       |                       $12.918$ |                                  $52.3624$ |
| room_s10_a30_w5           |$10\times10$| $30$       |                       $51.563$ |                                  $89.7547$ |




The solving time of the pruning approach could probably also be generally reduced further, if instead of just solving when new nodes are expanded, it is ensured that all conflict nodes are expanded before calling the solver. This is due to the most time during the execution of our approach being spent by the solver. So by making sure that every conflict node is expanded we reduce the amount of solver calls and thus the total runtime. 

It can genrallay be observed that our pruning approach takes more time than just simply solving the instance. This is due to the high amount of solver calls that have to be made because we are incrementally increasing the amount of nodes. This leads to a large computaion overhead that reflects in our results.

The only instances that where our approach was able to improve on the general solving strategy were the two maze benchmarks (`maze_s10_a25`, `maze_s10_a30`). In the results table above you can see that both are listed as `UNSAT` which is due to there only being a solution with a minimal time horizon of `68`. So when we compute these benchmarks again with this time horizon we get the results below:

| Instance                  | grid size | agents | Solving time (no pruning) in s |           Solving time (with pruning) in s |
| ------------------------- | --------- | ------ |-------------------------------:|-------------------------------------------:|
| maze_s10_a25              |$10\times10$| $25$       |    				2580.906s  |           					 2405.3621s  |
| maze_s10_a30              |$10\times10$| $30$       |    				1575.236s  |           			 		 1184.8219s  |

Here we can see some small improvements performance wise in the pruning approach. We suspect that for more difficult benchmarks with more nodes to prune this behavior could continue. But as it is observable now from our current benchmark selection the performance gains to be had only occur in very few cases and else often worsen the performance.

An idea could be to redefine the time steps to not only expand one new node at a time, but for every different collision node expand the grid by one step in each legal (reachable) direction.

Another appproach that could improve our pruning's performance would be to keep crutial context infiormation between solver calls. This would probably prove very difficult to implement though.  


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
