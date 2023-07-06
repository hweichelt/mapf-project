vertex((1,1..5)).
vertex((5,1..5)).
vertex((1..5,1)).
vertex((1..5,5)).

edge((X,Y),(X,Y+1)) :- vertex((X,Y)), vertex((X,Y+1)).
edge((X,Y),(X+1,Y)) :- vertex((X,Y)), vertex((X+1,Y)).
edge(X,Y) :- edge(Y,X).

agent(a1).
start(a1,(1,1)).
goal(a1,(1,5)).

spath(a1,(1,1),(1,2),1).
spath(a1,(1,2),(1,3),2).
spath(a1,(1,3),(1,4),3).
spath(a1,(1,4),(1,5),4).

agent(a2).
start(a2,(1,5)).
goal(a2,(1,1)).

spath(a2,(1,2),(1,1),4).
spath(a2,(1,3),(1,2),3).
spath(a2,(1,4),(1,3),2).
spath(a2,(1,5),(1,4),1).

#const horizon=12.
