:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(between)).
:- consult('board.pl').

other_player(player1, player2).
other_player(player2, player1).

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

help_menu:-
    clear_console,
    write('==================================\n'),
    write('       Flugelrad Game Guide       \n'),
    write('==================================\n\n'),
    
    write('Flugelrad is a strategy board game involving marbles and an impeller wheel. Dive into the key rules and strategies:\n\n'),
    write('When two players turn the wheel, this can be quite constructive, at least if they play a game of Flugelrad.\n'), 
    write('The game board consists of seven hexagonal spaces, each of which has a hole in its center for the impeller wheel.\n'), 
    write('The game is played with marbles; each player has their own color.\n'),
    write('On your turn, you reposition the impeller wheel, then rotate it as far as you like, thus moving up to six marbles at the same time.\n'), 
    write('The first player to form a contiguous cluster of at least six of their marbles wins.\n'),  
    write('But beware since you can easily move your opponents marbles as well.\n'),
    write('-----------------------------------------------------------------------------------------------------------------------------------\n\n'),
    write('1. Return to Main Menu\n'),
    write('2. Leave Game\n'),
    read_help_option(Choice),
    process_help_choice(Choice).

read_help_option(Choice) :-
    write('Enter your choice (1 or 2): '),
    read(Choice),
    validate_help_choice(Choice).

validate_help_choice(Choice) :-
    (Choice = 1 ; Choice = 2),
    !.

validate_help_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    read_help_option(Choice).

process_help_choice(1) :-
    main_menu.

process_help_choice(2) :-
    write('Thanks for playing!\n'),
    halt.

process_choice(2) :-
    help_menu.

read_option(Choice) :-
    write('Enter your choice (1, 2, or 3): '),
    read(Choice),
    validate_choice(Choice).

validate_choice(Choice) :-
    (Choice = 1 ; Choice = 2 ; Choice = 3),
    !.

validate_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    read_option(Choice).

process_choice(1) :-
    game_type.


process_choice(2) :-
    help_menu.


process_choice(3) :-
    write('Thanks for playing!\n'),
    halt.

%game_loop :-
%    clear_console,
%    print_board,
%    ( game_mode(bot_vs_bot) ->
%        bot_move(Hexagon, Direction);
%        format('Bot chose hexagon number ~w and played ~w~n',[Hexagon,Direction]);
%        flush_output ;
%        prompt_for_hexagon_and_direction(Hexagon, Direction) ),
%    ( Direction = exit -> true ;
%      handle_action(Hexagon, Direction),
%      game_loop ).

prompt_for_hexagon_and_direction(Hexagon, Direction) :-
    write('Enter the hexagon number (1-7) or type \'exit\' to end: '),
    read(Input),
    ( Input = exit -> Direction = exit, Hexagon = _ ;
      Hexagon = Input,
      write('Rotate clockwise or counterclockwise? (c/cc): '),
      read(Direction) ).

handle_action(_, exit). 
handle_action(Hexagon, Direction) :-
    (Direction = c -> rotate_hexagon_clockwise(Hexagon) ;
     Direction = cc -> rotate_hexagon_counterclockwise(Hexagon)),
    synchronize_neighbors(Hexagon).


bot_move(Hexagon, Direction) :-
    sleep(1),
    % Choose a random hexagon (1-7)
    random(RandomFloat),
    Hexagon is round(1 + RandomFloat * (7 - 1)),
    random_member(Direction, [c, cc]).
    %write('Bot chose hexagon: '), write(Hexagon), nl,
    %write('Bot chose direction: '), write(Direction), nl.


game_type:-  
    write('Please select game mode:\n'),
    write('1 - Human vs. Human\n'),
    write('2 - Human vs. Bot\n'),
    write('3 - Bot vs. Bot\n'),
    read_game_option(PlayChoice),
    process_play_choice(PlayChoice).

game_loop_human_vs_human :-
    clear_console,
    print_board,
    write('Player 1\'s turn:\n'),
    prompt_for_hexagon_and_direction(Hexagon1, Direction1),
    ( Direction1 = exit -> true ;
      handle_action(Hexagon1, Direction1),
      write('Player 2\'s turn:\n'),
      prompt_for_hexagon_and_direction(Hexagon2, Direction2),
      ( Direction2 = exit -> true ;
        handle_action(Hexagon2, Direction2),
        game_loop_human_vs_human )).

game_loop_human_vs_bot :-
    clear_console,
    print_board,
    write('Your turn:\n'),
    prompt_for_hexagon_and_direction(Hexagon, Direction),
    ( Direction = exit -> true ;
      handle_action(Hexagon, Direction),
      clear_console,
      write('Bot\'s turn:\n'),
      bot_move(BotHexagon, BotDirection),
      write('Bot chose hexagon: '), write(BotHexagon), nl,
      write('Bot chose direction: '), write(BotDirection), nl,
      sleep(2), % Pause for 2 seconds to let the user see the bot's move
      handle_action(BotHexagon, BotDirection),
      game_loop_human_vs_bot ).



game_loop_bot_vs_bot :-
    clear_console,
    print_board,
    bot_move(Hexagon, Direction),
    display_bot_move(Hexagon, Direction), % Display the bot's move
    sleep(2),
    handle_action(Hexagon, Direction),
    game_loop_bot_vs_bot.

display_bot_move(Hexagon, Direction) :-
    write('Bot chose hexagon: '), write(Hexagon), nl,
    write('Bot chose direction: '), write(Direction), nl.


read_game_option(PlayChoice) :-
    write('Enter your choice (1, 2, or 3): '),
    read(PlayChoice),
    validate_choice(PlayChoice).

process_play_choice(1) :-
    game_loop_human_vs_human.

process_play_choice(2) :-
    game_loop_human_vs_bot.

process_play_choice(3) :-
    game_loop_bot_vs_bot.

process_play_choice(_) :-
    write('Invalid play mode. Please try again.\n'),
    game_type.


gamestate([Board, player1, 0]) :-
    main_menu,
    clear_console,
    title,
    initial_board(Board), print_board(Board).

