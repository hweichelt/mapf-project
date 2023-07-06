# mapf-instance-format
This repository contains a lightweight mapf instance format

## Predicates

### Input (Instance)
- vertex/1
- edge/2
- agent/1
- start/2
- goal/2

The vertex predicare represents a node in the graph.

The edge/2 predicate represents an edge in a graph. Each argument is a node. An atom edge(P,P') indicates that in the given graphs, there is an edge between a node P and a node P'. All edges are undirected. Note that the edges are not necessarily reflexive.

The agent/1 predicate represents an agent.

The start/2 (goal/2) predicates represent the start (goal) position of an agent. An atom start(A,S) (goal(A,S)) indicates that agent A starts (ends) at position S.

### Output
- path/3
- plan/3

The path/3 predicate represents a path in the graph. The first argument is a robot ID. The second and third arguments are nodes in the graph. An atom path(R,P,P') says that robot R will go move from node P to node P'. This predicate is intended to work with acyclic paths.

The plan/3 predicate represents a step in sequence of actions for a given robot. The first argument is a robot ID. The second argument is the action being performed. The third predicate is the index of the action in the sequence. An atom plan(R,A,T) says that robot R performs action A after the first 1..T-1 actions in the sequence have been performed.

### Intermediate format
- spath/3

The spath/3 predicate repsents a shorted path for a given robot. The first argument is a robot ID. The second and third arguments are nodes. The atom spath(R,P,P') says that robot R traverses from node P to node P' in the given shortest path.

### Converting instances

To convert instance in the asprilo M or Md domain use the following command:

```
./convert-m-to-mif.sh <instance file> > converted_file.lp
```

