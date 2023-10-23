:- dynamic hexagon/2.

hexagon(1, ['G', 'B', 'B', 'B', 'G', 'B']).
hexagon(2, ['G', 'G', 'B', 'B', 'G', 'B']).
hexagon(3, ['G', 'B', 'B', 'G', 'G', 'B']).
hexagon(4, ['G', 'G', 'B', 'G', 'B', 'B']).
hexagon(5, ['B', 'G', 'B', 'B', 'G', 'G']).
hexagon(6, ['B', 'G', 'G', 'B', 'G', 'B']).
hexagon(7, ['B', 'G', 'B', 'G', 'B', 'G']).

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

print_marbles([]).
print_marbles([M|Ms]) :-
    write(M), write(' '),
    print_marbles(Ms).


rotate_hexagon(N) :-
    hexagon(N, Marbles),
    reverse(Marbles, [Last|RevRest]),
    reverse(RevRest, NewMarblesStart),
    append([Last], NewMarblesStart, RotatedMarbles),
    retract(hexagon(N, Marbles)),  % Remove old fact from knowledge base
    asserta(hexagon(N, RotatedMarbles)).  % Add new rotated fact to knowledge base
