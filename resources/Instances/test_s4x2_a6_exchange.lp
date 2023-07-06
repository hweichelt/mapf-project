vertex((1..4,1..2)).
edge((X,Y),(X,Y+1)) :- vertex((X,Y)), vertex((X,Y+1)).
edge((X,Y),(X+1,Y)) :- vertex((X,Y)), vertex((X+1,Y)).
edge(X,Y) :- edge(Y,X).

agent(a1).
start(a1,(1,1)).
goal(a1,(1,2)).
spath(a1,(1,1),(1,2),1).

agent(a2).
start(a2,(2,1)).
goal(a2,(2,2)).
spath(a2,(2,1),(2,2),1).

agent(a3).
start(a3,(3,1)).
goal(a3,(3,2)).
spath(a3,(3,1),(3,2),1).

agent(a1b).
start(a1b,(1,2)).
goal(a1b,(1,1)).
spath(a1b,(1,2),(1,1),1).

agent(a2b).
start(a2b,(2,2)).
goal(a2b,(2,1)).
spath(a2b,(2,2),(2,1),1).

agent(a3b).
start(a3b,(3,2)).
goal(a3b,(3,1)).
spath(a3b,(3,2),(3,1),1).

#const horizon=3.
