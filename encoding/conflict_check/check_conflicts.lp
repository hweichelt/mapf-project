% GENERATE THE ROBOT POSITIONS DURING THE PLAN

% NEIGHBOUR VERTICES
node(V) :- init(object(node,_),value(at,V)).
neighbours(value(at,(X1, Y1)), value(at,(X2, Y2))) :- node((X1, Y1)), node((X2, Y2)), |X1-X2|+|Y1-Y2|=1.

% INITIAL POSITION
position(object(robot,R), V, 0) :- init(object(robot,R), V).
% GENERATE POSITION VALUES
position(R, value(at,(X+DX,Y+DY)), T+1) :- occurs(R, action(move,(DX,DY)), T+1), position(R, value(at,(X,Y)), T).

% VERTEX CONFLICT
conflict_vertex(V) :- position(R1, V, T), position(R2, V, T), R1!=R2.
% SWAP CONFLICT
conflict_swap(V1, V2) :- position(R1, V1, T), position(R1, V2, T+1), position(R2, V2, T), position(R2, V1, T+1), neighbours(V1, V2), R1!=R2, V1!=V2.

% GENERATE CONFLICT NODES
conflict_node(V) :- conflict_vertex(V).
conflict_node(V) :- conflict_swap(V, _).
conflict_node(V) :- conflict_swap(_, V).

% #show conflict_vertex/1.
% #show conflict_swap/2.
% #show neighbours/2.
% #show position/3.
#show conflict_node/1.
