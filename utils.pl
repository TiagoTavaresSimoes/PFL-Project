% utils.pl

% Function to display the game menu
display_menu :-
    game_header(Header),
    write(Header), nl,
    menu(Items),
    display_menu_items(Items).

display_menu_items([]).
display_menu_items([Item|Rest]) :-
    write(Item), nl,
    display_menu_items(Rest).

% Function to get player input
get_player_input(Input) :-
    read(Input).

% Function to display the board
display_board(Board) :-
    % Logic to print the board
    true.

% Rotate wheel based on given direction and current state
rotate_wheel(Direction, CurrentState, NewState) :-
    % Define logic to rotate the wheel based on Direction and change the state from CurrentState to NewState
    true.

% Check if the move is valid
is_valid_move(Player, Move) :-
    % Logic to check if a given move is valid
    true.

% Place a marble on the board
place_marble(Player, Position, Board, NewBoard) :-
    % Logic to place a player's marble on a given position and return the updated board
    true.
clear_console:- 
    write('\33\[2J').