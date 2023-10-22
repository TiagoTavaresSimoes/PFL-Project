% Define the initial state of the board
board((0, 0), wheel).
board((0, 1), empty).
board((0, -1), empty).
board((1, 0), empty).
board((-1, 0), empty).
board((1, -1), empty).
board((-1, 1), empty).

% Marble positions
marble((X, Y), Color) :-
    board((X, Y), Color),
    Color \= empty,
    Color \= wheel.

% Checking if a position is empty
is_empty((X, Y)) :-
    board((X, Y), empty).

% Placing a marble on the board
place_marble((X, Y), Color) :-
    is_empty((X, Y)),
    retract(board((X, Y), empty)),
    assertz(board((X, Y), Color)).