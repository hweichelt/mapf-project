# mapf-project
Pruning project for MAPF

# Setup

+ We don't allow for:
	+ Vertex Conflicts
	+ Swap Conflicts

# Pruning Idea

+ We start by using the single agent shortest paths
	+ And throw away all verticies that aren't part of these plans
+ Then when combining these leads to a conflict we:
	1. Find the verticies where the conflict(s) occur
	2. Expand our selection of verticies to all cells reachabe by 1 from the conflict cells
	3. Try solving again ...

# Commands

Converting the MIF instances to asprilo format:

```bash
clingo --out-atomf=%s. --out-ifs="\n" -q1 resources/mif_to_asprilo.lp resources/Instances/test_s5_a2_square.lp | grep init > out.lp
```
