vertex((1..5,1..5)).
edge((X,Y),(X,Y+1)) :- vertex((X,Y)), vertex((X,Y+1)).
edge((X,Y),(X+1,Y)) :- vertex((X,Y)), vertex((X+1,Y)).
edge(X,Y) :- edge(Y,X).

agent(a1).
start(a1,(2,2)).
goal(a1,(3,4)).

spath(a1,(2,2),(2,3),1).
spath(a1,(2,3),(2,4),2).
spath(a1,(2,4),(3,4),3).

#const horizon=3.
