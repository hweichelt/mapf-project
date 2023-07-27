% PRUNING

% #const expansion_depth=N.
% input: conflict_node(value(at,(_,_)))

% INITIAL POSITION
position(object(robot,R), V, 0) :- init(object(robot,R), V).
% GENERATE POSITION VALUES
position(R, value(at,(X+DX,Y+DY)), T+1) :- occurs(R, action(move,(DX,DY)), T+1), position(R, value(at,(X,Y)), T).

% INITIAL CONFLICT NODE
away_from((X,Y), (X,Y), 0) :- conflict_node(value(at,(X,Y))).
% GENERATE DISTANCE FROM CONFLICT
away_from((X_CONFLICT,Y_CONFLICT), (X2,Y2), D+1) :- away_from((X_CONFLICT,Y_CONFLICT), (X,Y), D), neighbours((X,Y), (X2,Y2)), D+1 < expansion_depth.

expanded_node(X,Y) :- away_from(_, (X,Y),_).

grid_node(X,Y) :- init(object(node,_),value(at,(X,Y))).
neighbours((X1, Y1), (X2, Y2)) :- grid_node(X1, Y1), grid_node(X2, Y2), |X1-X2|+|Y1-Y2|=1.
sap_node(X,Y) :- position(_, value(at,(X,Y)), _).

expanded_node(X,Y) :- sap_node(X,Y).

% #show grid_node/2.
% #show sap_node/2.
#show expanded_node/2.
% #show away_from/3.
