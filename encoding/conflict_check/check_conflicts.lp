% GENERATE THE ROBOT POSITIONS DURING THE PLAN

% NEIGHBOUR VERTICES
node(V) :- init(object(node,_),value(at,V)).
neighbours((X1, Y1), (X2, Y2)) :- node((X1, Y1)), node((X2, Y2)), |X1-X2|+|Y1-Y2|=1.

% INITIAL POSITION
position(object(robot,R), V, 0) :- init(object(robot,R), V).
% GENERATE POSITION VALUES
position(R, value(at,(X+DX,Y+DY)), T+1) :- occurs(R, action(move,(DX,DY)), T+1), position(R, value(at,(X,Y)), T).

% VERTEX CONFLICT
conflict_vertex(V, T) :- position(R1, V, T), position(R2, V, T), R1!=R2.
% SWAP CONFLICT
conflict_swap(V1, V2, T) :- position(R1, V1, T), position(R1, V2, T+1), position(R2, V2, T), position(R2, V1, T+1), neighbours(V1, V2).

conflict_swap(value(at,(1,5)), value(at,(2,5)), 2).

% GENERATE CONFLICT NODES
conflict_node(V) :- conflict_vertex(V, _).
conflict_node(V) :- conflict_swap(V, _, _).
conflict_node(V) :- conflict_swap(_, V, _).


% #show conflict_vertex/2.
% #show conflict_swap/3.
% #show position/3.
#show conflict_node/1.
