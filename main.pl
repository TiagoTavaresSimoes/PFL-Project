% Including other files containing definitions of board, configs, data, utilities, and menu functionalities.
:- consult(board).
:- consult(configs).
:- consult(data).
:- consult(utils).
:- consult(menu).

% play/0
% Starts the game process by displaying the main menu and potentially initializing the game state
% and starting the game cycle (commented out, suggesting it may be a part of future implementation).
play :-
    main_menu.
    %configurations(GameState),      
    %game_cycle(GameState),

% init_game_state(-GameState)
% A placeholder predicate meant to initialize the default game state. This will need to be
% filled in with the actual logic necessary for setting up the game state before starting.
init_game_state(GameState) :-
    % Example logic to set up your default game state.
    % Replace with your actual logic.
    init_state(10, GameState).


% init_state(+Size, -GameState)
% Initializes the game state (presumably the game board) with a certain size. The GameState is
% a list of length Size, and each element is itself a list (row of the board) initialized by the init_row predicate.
init_state(Size, GameState) :-
    length(GameState, Size),
    maplist(init_row(Size), GameState).

% main/0
% The main entry point for executing the game. It is responsible for initializing the console,
% displaying an introduction, initializing a random state (possibly for random elements of the game),
% and beginning the game process.
main :-
    clear_console,
    display_intro,
    init_random_state,
    init_game.