:- dynamic hexagon/2.

hexagon(1, ['G', 'B', 'X', 'X', 'X', 'B']).
hexagon(2, ['G', 'B', 'G', 'X', 'X', 'X']).
hexagon(3, ['G', 'X', 'X', 'X', 'G', 'B']).
hexagon(4, ['X', 'X', 'X', 'X', 'X', 'X']).
hexagon(5, ['X', 'B', 'G', 'B', 'X', 'X']).
hexagon(6, ['X', 'X', 'X', 'B', 'G', 'B']).
hexagon(7, ['X', 'X', 'G', 'B', 'G', 'X']).


display_hexagons :-
    display_hexagon(1).

display_hexagon(8) :- !.  
display_hexagon(N) :-
    hexagon(N, Marbles),
    write('Hexagon '), write(N), write(': '),
    print_marbles(Marbles),
    nl,
    Next is N + 1,
    display_hexagon(Next).

rotate_hexagon_counterclockwise(N) :-
    hexagon(N, Marbles),
    reverse(Marbles, [Last|RevRest]),
    reverse(RevRest, NewMarblesStart),
    append([Last], NewMarblesStart, RotatedMarbles),
    retract(hexagon(N, Marbles)),  
    asserta(hexagon(N, RotatedMarbles)),  
    synchronize_neighbors(N).

rotate_hexagon_clockwise(N) :-
    hexagon(N, Marbles),
    rotate_once_clockwise(Marbles, RotatedMarbles),
    retract(hexagon(N, Marbles)),
    asserta(hexagon(N, RotatedMarbles)),
    synchronize_neighbors(N).

rotate_once_clockwise([First|Rest], RotatedMarbles) :-
    append(Rest, [First], RotatedMarbles).

% Synchronization rules:
synchronize_neighbors(1) :-
    hexagon(1, [_,_,H1_3,H1_4,H1_5,_]),
    sync_neighbors(1, 3, H1_3),
    sync_neighbors(1, 4, H1_4),
    sync_neighbors(1, 5, H1_5).

synchronize_neighbors(2) :-
    hexagon(2, [_,_,_,H2_4,H2_5,H2_6]),
    sync_neighbors(2, 4, H2_4),
    sync_neighbors(2, 5, H2_5),
    sync_neighbors(2, 6, H2_6).

synchronize_neighbors(3) :-
    hexagon(3, [_,H3_2,H3_3,H3_4,_,_]),
    sync_neighbors(3, 2, H3_2),
    sync_neighbors(3, 3, H3_3),
    sync_neighbors(3, 4, H3_4).

synchronize_neighbors(4) :-
    hexagon(4, [H4_1,H4_2,H4_3,H4_4,H4_5,H4_6]),
    sync_neighbors(4, 1, H4_1),
    sync_neighbors(4, 2, H4_2),
    sync_neighbors(4, 3, H4_3),
    sync_neighbors(4, 4, H4_4),
    sync_neighbors(4, 5, H4_5),
    sync_neighbors(4, 6, H4_6).

synchronize_neighbors(5) :-
    hexagon(5, [H5_1,_,_,_,H5_5,H5_6]),
    sync_neighbors(5, 1, H5_1),
    sync_neighbors(5, 5, H5_5),
    sync_neighbors(5, 6, H5_6).

synchronize_neighbors(6) :-
    hexagon(6, [H6_1,H6_2,H6_3,_,_,_]),
    sync_neighbors(6, 1, H6_1),
    sync_neighbors(6, 2, H6_2),
    sync_neighbors(6, 3, H6_3).

synchronize_neighbors(7) :-
    hexagon(7, [H7_1,H7_2,_,_,_,H7_6]),
    sync_neighbors(7, 1, H7_1),
    sync_neighbors(7, 2, H7_2),
    sync_neighbors(7, 6, H7_6).

sync_neighbors(1, 3, M) :- change_marble(2, 6, M).
sync_neighbors(1, 4, M) :- change_marble(4, 1, M).
sync_neighbors(1, 5, M) :- change_marble(3, 2, M).
sync_neighbors(2, 4, M) :- change_marble(5, 1, M).
sync_neighbors(2, 5, M) :- change_marble(4, 2, M).
sync_neighbors(2, 6, M) :- change_marble(1, 3, M).
sync_neighbors(3, 2, M) :- change_marble(1, 5, M).
sync_neighbors(3, 3, M) :- change_marble(4, 6, M).
sync_neighbors(3, 4, M) :- change_marble(6, 1, M).
sync_neighbors(4, 1, M) :- change_marble(1, 4, M).
sync_neighbors(4, 2, M) :- change_marble(2, 5, M).
sync_neighbors(4, 3, M) :- change_marble(5, 6, M).
sync_neighbors(4, 4, M) :- change_marble(7, 1, M).
sync_neighbors(4, 5, M) :- change_marble(6, 2, M).
sync_neighbors(4, 6, M) :- change_marble(3, 3, M).
sync_neighbors(5, 1, M) :- change_marble(2, 4, M).
sync_neighbors(5, 5, M) :- change_marble(7, 2, M).
sync_neighbors(5, 6, M) :- change_marble(4, 3, M).
sync_neighbors(6, 1, M) :- change_marble(3, 4, M).
sync_neighbors(6, 2, M) :- change_marble(4, 5, M).
sync_neighbors(6, 3, M) :- change_marble(7, 6, M).
sync_neighbors(7, 1, M) :- change_marble(4, 4, M).
sync_neighbors(7, 2, M) :- change_marble(5, 5, M).
sync_neighbors(7, 6, M) :- change_marble(6, 3, M).

change_marble(Hexagon, Position, M) :-
    hexagon(Hexagon, Marbles),
    replace_nth(Marbles, Position, M, NewMarbles),
    retract(hexagon(Hexagon, Marbles)),
    asserta(hexagon(Hexagon, NewMarbles)).

replace_nth([_|T], 1, X, [X|T]).
replace_nth([H|T], N, X, [H|R]) :-
    N > 1,
    N1 is N-1,
    replace_nth(T, N1, X, R).

print_marbles([]).
print_marbles([M|Ms]) :-
    write(M), write(' '),
    print_marbles(Ms).


print_board :-
    hexagon(1, [H1_1, H1_2, H1_3, H1_4, H1_5, H1_6]),
    hexagon(2, [H2_1, H2_2, H2_3, H2_4, H2_5, H2_6]),
    hexagon(3, [H3_1, H3_2, H3_3, H3_4, H3_5, H3_6]),
    hexagon(4, [H4_1, H4_2, H4_3, H4_4, H4_5, H4_6]),
    hexagon(5, [H5_1, H5_2, H5_3, H5_4, H5_5, H5_6]),
    hexagon(6, [H6_1, H6_2, H6_3, H6_4, H6_5, H6_6]),
    hexagon(7, [H7_1, H7_2, H7_3, H7_4, H7_5, H7_6]),
    
    format("             / ~w \\ \n", [H1_1]),
    format("            ~w     ~w\n", [H1_2, H1_6]),
    format("       / ~w \\|     |/ ~w \\ \n", [H2_1, H3_1]),
    format("      ~w     ~w     ~w     ~w\n", [H2_2, H2_6, H3_2, H3_6]),
    format("      |     |\\ ~w /|     |\n", [H1_4]),
    format("      ~w     ~w     ~w     ~w\n", [H2_3, H2_5, H3_3, H3_5]),
    format("       \\ ~w /|     |\\ ~w /\n", [H2_4, H3_4]),
    format("       ~w    ~w     ~w    ~w \n", [H5_2, H5_6, H6_2, H6_6]),
    format("       |    |\\ ~w /|    |\n", [H4_4]),
    format("       ~w    ~w     ~w    ~w \n", [H5_3, H5_5, H6_3, H6_5]),
    format("       \\ ~w /|     |\\ ~w /\n", [H5_2, H6_6]),
    format("            ~w     ~w\n", [H7_3, H7_5]),
    format("             \\ ~w /\n", [H7_4]).

% Connections within the same hexagon
% formato: connection(Hexagon, Marble, Hexagon, NextMarble)

% Hexagon 1
connection(1, 1, 1, 2).
connection(1, 2, 1, 1).
connection(1, 2, 1, 3).
connection(1, 3, 1, 2).
connection(1, 3, 1, 4).
connection(1, 4, 1, 3).
connection(1, 4, 1, 5).
connection(1, 5, 1, 4).
connection(1, 5, 1, 6).
connection(1, 6, 1, 5).

% Hexagon 2
connection(2, 1, 2, 2).
connection(2, 2, 2, 1).
connection(2, 2, 2, 3).
connection(2, 3, 2, 2).
connection(2, 3, 2, 4).
connection(2, 4, 2, 3).
connection(2, 4, 2, 5).
connection(2, 5, 2, 4).
connection(2, 5, 2, 6).
connection(2, 6, 2, 5).

% Hexagon 3
connection(3, 1, 3, 2).
connection(3, 2, 3, 1).
connection(3, 2, 3, 3).
connection(3, 3, 3, 2).
connection(3, 3, 3, 4).
connection(3, 4, 3, 3).
connection(3, 4, 3, 5).
connection(3, 5, 3, 4).
connection(3, 5, 3, 6).
connection(3, 6, 3, 5).

% Hexagon 4
connection(4, 1, 4, 2).
connection(4, 2, 4, 1).
connection(4, 2, 4, 3).
connection(4, 3, 4, 2).
connection(4, 3, 4, 4).
connection(4, 4, 4, 3).
connection(4, 4, 4, 5).
connection(4, 5, 4, 4).
connection(4, 5, 4, 6).
connection(4, 6, 4, 5).
connection(4, 6, 4, 1).
connection(4, 1, 4, 6).

% Hexagon 5
connection(5, 1, 5, 2).
connection(5, 2, 5, 1).
connection(5, 2, 5, 3).
connection(5, 3, 5, 2).
connection(5, 3, 5, 4).
connection(5, 4, 5, 3).
connection(5, 4, 5, 5).
connection(5, 5, 5, 4).
connection(5, 5, 5, 6).
connection(5, 6, 5, 5).
connection(5, 6, 5, 1).
connection(5, 1, 5, 6).

% Hexagon 6
connection(6, 1, 6, 2).
connection(6, 2, 6, 1).
connection(6, 2, 6, 3).
connection(6, 3, 6, 2).
connection(6, 3, 6, 4).
connection(6, 4, 6, 3).
connection(6, 4, 6, 5).
connection(6, 5, 6, 4).
connection(6, 5, 6, 6).
connection(6, 6, 6, 5).
connection(6, 6, 6, 1).
connection(6, 1, 6, 6).

% Hexagon 7
connection(7, 1, 7, 2).
connection(7, 2, 7, 1).
connection(7, 2, 7, 3).
connection(7, 3, 7, 2).
connection(7, 3, 7, 4).
connection(7, 4, 7, 3).
connection(7, 4, 7, 5).
connection(7, 5, 7, 4).
connection(7, 5, 7, 6).
connection(7, 6, 7, 5).


% Inter-hexagon connections
% formato: connection(Hexagon, Marble, AdjacentHexagon, AdjacentMarble)

% Between hexagon 1 and 2
connection(1, 2, 2, 6).
connection(2, 6, 1, 2).
connection(1, 3, 2, 1).
connection(2, 1, 1, 3).
connection(1, 3, 2, 5).
connection(2, 5, 1, 3).
connection(1, 4, 2, 5).
connection(2, 5, 1, 4).
connection(1, 4, 2, 6).
connection(2, 6, 1, 4).

% Between hexagon 1 and 3
connection(1, 5, 3, 3).
connection(3, 3, 1, 5).
connection(1, 5, 3, 1).
connection(3, 1, 1, 5).
connection(1, 6, 3, 2).
connection(3, 2, 1, 6).
connection(1, 4, 3, 3).
connection(3, 3, 1, 4).
connection(1, 4, 3, 2).
connection(3, 2, 1, 4).

% Between hexagon 1 and 4
connection(1, 3, 4, 1).
connection(4, 1, 1, 3).
connection(1, 3, 4, 2).
connection(4, 2, 1, 3).
connection(1, 4, 4, 2).
connection(4, 2, 1, 4).
connection(1, 4, 4, 6).
connection(4, 6, 1, 4).
connection(1, 5, 4, 1).
connection(4, 1, 1, 5).
connection(1, 5, 4, 6).
connection(4, 6, 1, 5).

% Between hexagon 2 and 5
connection(2, 4, 5, 2).
connection(5, 2, 2, 4).
connection(2, 4, 5, 6).
connection(5, 6, 2, 4).
connection(2, 5, 5, 6).
connection(5, 6, 2, 5).
connection(2, 5, 5, 1).
connection(5, 1, 2, 5).
connection(2, 3, 5, 1).
connection(5, 1, 2, 3).

% Between hexagon 2 and 4
connection(2, 6, 4, 2).
connection(4, 2, 2, 6).
connection(2, 6, 4, 1).
connection(4, 1, 2, 6).
connection(2, 5, 4, 1).
connection(4, 1, 2, 5).
connection(2, 5, 4, 3).
connection(4, 3, 2, 5).
connection(2, 4, 4, 3).
connection(4, 3, 2, 4).
connection(2, 4, 4, 2).
connection(4, 2, 2, 4).

% Between hexagon 3 and 4
connection(3, 2, 4, 6).
connection(4, 6, 3, 2).
connection(3, 2, 4, 1).
connection(4, 1, 3, 2).
connection(3, 3, 4, 1).
connection(4, 1, 3, 3).
connection(3, 3, 4, 5).
connection(4, 5, 3, 3).
connection(3, 4, 4, 6).
connection(4, 6, 3, 4).
connection(3, 4, 4, 5).
connection(4, 5, 3, 4).

% Between hexagon 3 and 6
connection(3, 4, 6, 6).
connection(6, 6, 3, 4).
connection(3, 4, 6, 2).
connection(6, 2, 3, 4).
connection(3, 3, 6, 2).
connection(6, 2, 3, 3).
connection(3, 3, 6, 1).
connection(6, 1, 3, 3).
connection(3, 5, 6, 1).
connection(6, 1, 3, 5).

% Between hexagon 4 and 5
connection(4, 2, 5, 6).
connection(5, 6, 4, 2).
connection(4, 2, 5, 1).
connection(5, 1, 4, 2).
connection(4, 3, 5, 1).
connection(5, 1, 4, 3).
connection(4, 3, 5, 5).
connection(5, 5, 4, 3).
connection(4, 4, 5, 5).
connection(5, 5, 4, 4).
connection(4, 4, 5, 6).
connection(5, 6, 4, 4).

% Between hexagon 4 and 6
connection(4, 4, 6, 2).
connection(6, 2, 4, 4).
connection(4, 4, 6, 3).
connection(6, 3, 4, 4).
connection(4, 5, 6, 1).
connection(6, 1, 4, 5).
connection(4, 5, 6, 3).
connection(6, 3, 4, 5).
connection(4, 6, 6, 1).
connection(6, 1, 4, 6).
connection(4, 6, 6, 2).
connection(6, 2, 4, 6).

% Between hexagon 4 and 7
connection(4, 3, 7, 2).
connection(7, 2, 4, 3).
connection(4, 3, 7, 1).
connection(7, 1, 4, 3).
connection(4, 4, 7, 6).
connection(7, 6, 4, 4).
connection(4, 4, 7, 2).
connection(7, 2, 4, 4).
connection(4, 5, 7, 6).
connection(7, 6, 4, 5).
connection(4, 5, 7, 1).
connection(7, 1, 4, 5).

% Between hexagon 5 and 7
connection(5, 4, 7, 2).
connection(7, 2, 5, 4).
connection(5, 5, 7, 1).
connection(7, 1, 5, 5).
connection(5, 5, 7, 3).
connection(7, 3, 5, 5).
connection(5, 6, 7, 1).
connection(7, 1, 5, 6).
connection(5, 6, 7, 2).
connection(7, 2, 5, 6).

% Between hexagon 6 and 7
connection(6, 2, 7, 1).
connection(7, 1, 6, 2).
connection(6, 2, 7, 6).
connection(7, 6, 6, 2).
connection(6, 3, 7, 1).
connection(7, 1, 6, 3).
connection(6, 3, 7, 5).
connection(7, 5, 6, 3).
connection(6, 4, 7, 6).
connection(7, 6, 6, 4).


synchronize_neighbors(N) :-
    hexagon(N, Marbles),
    sync_from_list(N, Marbles).

sync_from_list(_, []).
sync_from_list(N, [M|Ms]) :-
    length(Ms, Remaining),
    Position is 7 - Remaining,
    (sync_neighbors(N, Position, M); true),
    sync_from_list(N, Ms).

winner_exists :-
    hexagon(Hexagon, Marbles),
    nth1(Position, Marbles, Marble),
    Marble \= 'X',  % Exclude empty marbles
    dfs(Hexagon, Position, Marble, 1, [], _WinningPath),
    !.  % Cut to stop searching further when a winning sequence is found

dfs(_, _, _, 6, Visited, Visited).

dfs(Hexagon, Position, Marble, Depth, Visited, NewVisited) :-
    Depth < 6,
    connection(Hexagon, Position, NextHexagon, NextPosition),
    \+ member((NextHexagon, NextPosition), Visited),
    hexagon(NextHexagon, NextMarbles),
    nth1(NextPosition, NextMarbles, NextMarble),
    NextMarble = Marble,  % Ensure the marble type is the same
    NextDepth is Depth + 1,
    dfs(NextHexagon, NextPosition, Marble, NextDepth, [(Hexagon, Position)|Visited], NewVisited).




























