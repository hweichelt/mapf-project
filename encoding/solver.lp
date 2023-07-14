% SOLVER

#const upper_bound=10.

%Set time horizon
timestep(1..upper_bound).

% Robots
robot(R) :- init(object(robot,R),value(at,_)).

% Goals
goal(S, V) :- init(object(shelf,S),value(at,V)).

% Nodes
node(V) :- init(object(node,_),value(at,V)).

% Generate Directions
direction((X,Y)) :- X=-1..1, Y=-1..1, |X+Y|=1.

%Neighboring nodes
neighbours((X1, Y1), (X2, Y2)) :- node((X1, Y1)), node((X2, Y2)), |X1-X2|+|Y1-Y2|=1.


% Generate Movements for each robot at every timestep
 
{ movement(R, D, T) : direction(D) }1 :- robot(R), timestep(T).


% From the movements genereate positional data

position(R, V, 0) :- init(object(robot,R), value(at,V)).  %V=(X,Y)
% For moving actions
position(R, (X+DX,Y+DY), T) :- movement(R, (DX, DY), T), position(R, (X,Y), T-1), robot(R), timestep(T).
% For waiting actions
position(R, V, T) :- not movement(R, _, T), position(R, V, T-1), robot(R), timestep(T).

% Find Conflicts

conflict_vertex(V, T) :- position(R1, V, T), position(R2, V, T), R1!=R2.
conflict_swap(V1, V2, T) :- position(R1, V1, T), position(R1, V2, T+1), position(R2, V2, T), position(R2, V1, T+1), neighbours(V1, V2).


% Constraints on conflicting plans
:- conflict_swap(_,_,_).
:- conflict_vertex(_,_).

% Constrain impossible moves
:- position(_, V, _), not node(V).

% Contraint for goal condition
:- not position(R, V, upper_bound), goal(R, V).

% Minimize Makespan
#minimize{ T,R : movement(R, _, T), robot(R) }.

% Transform movement atoms to occurs_final in asprilo format
occurs_final(object(robot,R), action(move, D), T) :- movement(R, D, T).

#show occurs_final/3.
