:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(system), [now/1]).
:- consult('board.pl'). % Assuming your board details are in board.pl

other_player(player1, player2).
other_player(player2, player1).

% flugelrad/0
% Game header
flugelrad:-
    write('--------------------------------------\n'),
    write('      Welcome to Flugelrad!           \n'),
    write('--------------------------------------\n\n').

main_menu :-
    clear_console,
    flugelrad,
    write('Main Menu\n'),
    write('1. Play Game\n'),
    write('2. Help\n'),
    write('3. Leave Game\n'),
    read_option(Choice),
    process_choice(Choice).


read_option(Choice) :-
    write('Enter your choice (1, 2, or 3): '),
    read(Choice),
    validate_choice(Choice).

% Cut to prevent backtracking
validate_choice(Choice) :-
    (Choice = 1 ; Choice = 2 ; Choice = 3),
    !.




validate_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    read_option(Choice).

process_choice(1) :-
    menu.

process_choice(2) :-
    % Need to maybe do another sub-menu after entering help menu to send back to main menu or quit the app.
    help_menu,
    main_menu.

process_choice(3) :-
    write('Thanks for playing!\n'),
    halt.


% menu/0
% Main menu
menu:-  
    write('Please select game mode:\n'),
    write('1 - Human vs. Human\n'),
    write('2 - Human vs. Bot\n'),
    write('3 - Bot vs. Bot\n').
    read_game_option(PlayChoice),
    process_play_choice(PlayChoice).

read_game_option(PlayChoice) :-
    write('Enter your choice (1, 2, or 3): '),
    read(PlayChoice),
    validate_choice(PlayChoice).

process_play_choice(_) :-
    write('Invalid play mode. Please try again.\n'),
    menu.

process_play_choice(1) :-
    write('Human vs. Human game ...\n').
    % asserta(player_name(player1, 'João')), 
    % asserta(player_name(player2, 'Pedro')). % testing
    % read_name(player1), 
    % read_name(player2).

process_play_choice(2) :-
    write('Human vs. Bot game ...\n').

process_play_choice(3) :-
    write('Bot vs. Bot game ...\n').



% init_game/0
% Initializes the game.
%init_game :-
%    write('Choose a difficulty:\n'),
%    write('1. Easy (10x10)\n'),
%    write('2. Medium (13x13)\n'),
%    write('3. Hard (16x16)\n'),
%    get_option(1, 3, 'Difficulty', Difficulty),
%    game_size(Difficulty, Size),
%    init_state(Size, Board),
%    start_game(Board).

help_menu :-
    % Just to visualize the help menu for now
    write('When two players turn the wheel, this can be quite constructive — at least if they play a game of Flügelrad. The game board consists of seven hexagonal spaces, each of which has a hole in its center for the impeller wheel. The game is played with marbles; each player has their own color. On your turn, you reposition the impeller wheel, then rotate it as far as you like, thus moving up to six marbles at the same time. The first player to form a contiguous cluster of at least six of their marbles wins. But beware since you can easily move your opponents marbles as well.').

title :-
    write(' _________________________________________________________________________'),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write('|                          Welcome to Flugelrad!                          |'),nl,
    write('|                                                                         |'),nl,
    write('|                          Let´s start the Game!                          |'),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write('|                            We Hope you enjoy!                           |'),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write('|                                                                         |'),nl,
    write('|_________________________________________________________________________|'),nl,nl.

% initialize gamestate with board, first player is player1 and 0 totalmoves
gamestate([Board, player1, 0]) :-
    main_menu,
    clear_console,
    title,
    initial_board(Board), print_board(Board).

% choose_difficulty(+Bot)
% Choose Bot difficulty (1 or 2)
%choose_difficulty(Bot) :-
%    format('Please select ~a status:\n', [Bot]),
%    write('1 - Random\n'),
%    write('2 - Greedy\n'),
%    get_option(1, 2, 'Difficulty', Option), !,
%    asserta((difficulty(Bot, Option))).

% option(+N)
% Main menu options. Each represents a game mode.
%option(1):-
%    write('Human vs. Human\n'),
%    get_name(player1), get_name(player2).
%option(2):-
%    write('Human vs. Bot\n'),
%    get_name(player1),
%    asserta((name_of(player2, 'bot'))), !, 
%    choose_difficulty(player2).
%option(3):-
%    write('Bot vs. Bot\n'),
%    asserta((name_of(player1, 'bot1'))),
%    asserta((name_of(player2, 'bot2'))), !,
%    choose_difficulty(player1),
%    choose_difficulty(player2).

% choose_player(-Player)
% Unifies player with the player who will start the game
%choose_player(Player):-
%    name_of(player1, Name1),
%    name_of(player2, Name2),
%    format('Who starts playing?\n1 - ~a\n2 - ~a\n', [Name1, Name2]),
%    get_option(1, 2, 'Select', Index),
%    nth1(Index, [player1, player2], Player).



% set_mode/0
% Game mode choice
% set_mode :-
%    menu,
%    get_option(1, 3, 'Mode', Option), !,
%    option(Option).

% configurations(-GameState)
% Initialize GameState with Board and the first Player
% configurations([Board,Player]):-
%   flugelrad,
%    set_mode,
%    init_random_state, % You'll need to define how the random state is initialized
%    choose_player(Player),
%    init_state(Board). % You'll need to define how the board is initialized for Flügelrad