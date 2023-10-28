:- consult(board).
:- consult(configs).
:- consult(data).
:- consult(utils).


% play/0
% Starts the game and clears data when it ends 
play :-
    main_menu.
    %configurations(GameState),      
    %game_cycle(GameState),

% init_game_state(-GameState)
% Logic to set up your default game state. Placeholder function; adjust to your needs.
init_game_state(GameState) :-
    % Example logic to set up your default game state.
    % Replace with your actual logic.
    init_state(10, GameState).

% init_state(+Size, -GameState)
% Initializes the game state (board) based on the given size.
init_state(Size, GameState) :-
    length(GameState, Size),
    maplist(init_row(Size), GameState).

% main/0
% Main predicate for game execution.
main :-
    clear_console,
    display_intro,
    init_random_state,
    init_game.


