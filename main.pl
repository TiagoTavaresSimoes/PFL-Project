:- consult(data).
:- consult(utils).
:- consult(board).
:- consult(configs).

% play/0
% Starts the game and clears data when it ends 
play :-
    configurations(GameState),      
    game_cycle(GameState),
    clear_data.

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

% display_intro/0
% Displays the game´s introduction.
display_intro :-
    write('Welcome to Flügelrad!\n\n'),
    write('Follow the instructions and have fun!\n'),
    write('Press enter to continue...\n'),
    clear_buffer.

% init_game/0
% Initializes the game.
init_game :-
    write('Choose a difficulty:\n'),
    write('1. Easy (10x10)\n'),
    write('2. Medium (13x13)\n'),
    write('3. Hard (16x16)\n'),
    get_option(1, 3, 'Difficulty', Difficulty),
    game_size(Difficulty, Size),
    init_state(Size, Board),
    start_game(Board).

% game_size(+Difficulty, -Size)
% Maps difficulty to board size.
game_size(1, 10).
game_size(2, 13).
game_size(3, 16).

% start_game(+Board)
% Manages the game turns, checks for game over conditions, etc.
start_game(Board) :-
    % Define the game loop here, for instance:
    % - display the board
    % - get moves from players
    % - check for endgame conditions
    % and so on
    write('Game started!'), % Placeholder
    nl.

