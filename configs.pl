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

game_loop :-
    clear_console,
    print_board,
    ( winner_exists ->
        writeln('We have a winner!'),
        true;
        ( game_mode(bot_vs_bot) ->
            bot_move(Hexagon, Direction, NumberOfSpins),
            format('Bot chose hexagon number ~w, played ~w, and spun the wheel ~w times~n',[Hexagon,Direction,NumberOfSpins]),
            flush_output ;
            prompt_for_hexagon_and_direction(Hexagon, Direction, NumberOfSpins) ),
        ( Direction = exit -> true ;
          handle_action(Hexagon, Direction, NumberOfSpins),
          game_loop )
    ).

prompt_for_hexagon_and_direction(Hexagon, Direction, NumberOfSpins) :-
    write('Enter the hexagon number (1-7) or type \'exit\' to end: '),
    read(Input),
    ( 
        Input = exit -> Direction = exit, Hexagon = _, NumberOfSpins = 0
        ;
        integer(Input), between(1, 7, Input) -> Hexagon = Input,
        prompt_for_direction(Direction),
        prompt_for_spin_count(NumberOfSpins)
        ;
        write('Invalid input. Please enter a number between 1 and 7 or \'exit\'.'), nl,
        prompt_for_hexagon_and_direction(Hexagon, Direction, NumberOfSpins)
    ).

prompt_for_direction(Direction) :-
    write('Rotate clockwise or counterclockwise? (c/cc): '),
    read(TempDirection),
    ( 
        (TempDirection = c ; TempDirection = cc) -> Direction = TempDirection
        ;
        write('Invalid input. Please enter c or cc.'), nl,
        prompt_for_direction(Direction)
    ).

prompt_for_spin_count(NumberOfSpins) :-
    write('How many times do you want to spin the wheel (1-5)? '),
    read(TempNumberOfSpins),
    ( 
        integer(TempNumberOfSpins), between(1, 5, TempNumberOfSpins) -> NumberOfSpins = TempNumberOfSpins
        ;
        write('Invalid input. Please enter a number between 1 and 5.'), nl,
        prompt_for_spin_count(NumberOfSpins)
    ).

handle_action(_, exit). 
handle_action(Hexagon, Direction) :-
    (Direction = c -> rotate_hexagon_clockwise(Hexagon) ;
     Direction = cc -> rotate_hexagon_counterclockwise(Hexagon)),
    synchronize_neighbors(Hexagon).


%bot_move(Hexagon, Direction) :-
%    sleep(1),
%    % Choose a random hexagon (1-7)
%    random(RandomFloat),
%    Hexagon is round(1 + RandomFloat * (7 - 1)),
%    random_member(Direction, [c, cc]).
%    %write('Bot chose hexagon: '), write(Hexagon), nl,
%    %write('Bot chose direction: '), write(Direction), nl.

bot_move(BotName, Hexagon, Direction, NumberOfSpins) :-
    sleep(1),
    % Choose a random hexagon (1-7)
    random(RandomFloat),
    Hexagon is round(1 + RandomFloat * (7 - 1)),
    random_member(Direction, [c, cc]),
    % Randomly choose how many times to spin the hexagon (ex: 1-5 times for this example)
    random_in_range(1, 5, NumberOfSpins),
    display_bot_move(BotName, Hexagon, Direction, NumberOfSpins).

max_depth(Depth) :- Depth is 3.


% Define the greedy bot move function
greedy_bot_move(Board, BestHexagon, BestDirection, BestNumberOfSpins) :-
    max_depth(Depth),
    minimax(Board, Depth, BestHexagon, BestDirection, BestNumberOfSpins, _Score).

% The minimax algorithm with depth, returns the best move and its score.
minimax(Board, Depth, Hexagon, Direction, NumberOfSpins, Score) :-
    ( Depth =< 0 ->
        evaluate_board(Board, Score) % If we have reached the maximum depth, evaluate the board
    ; otherwise ->
        findall(
            [H, D, NS, S],
            ( possible_move(H, D, NS), % For all possible moves
              apply_move(Board, H, D, NS, NewBoard), % Apply the move
              minimax(NewBoard, Depth - 1, _, _, _, S) % Recurse for the next depth
            ),
            MovesScores
        ),
        % Decide whether to maximize or minimize based on whose turn it is
        % For instance, if it's the bot's turn, we want to maximize the score.
        ( is_maximizing_player(Board) ->
            max_member([Hexagon, Direction, NumberOfSpins, Score], MovesScores)
        ; otherwise ->
            min_member([Hexagon, Direction, NumberOfSpins, Score], MovesScores)
        )
    ).

% A utility predicate to check if it's the maximizing player's turn, assuming we're evaluating from the bot's perspective.
is_maximizing_player(Board) :-
    % Implement the logic to determine if it's the maximizing player's (bot's) turn.
    % For simplicity, this example assumes it's always the bot's turn when minimax is called.
    true.

% Apply a move to the board.
apply_move(Board, Hexagon, Direction, NumberOfSpins, NewBoard) :-
    % You need to implement the logic to mutate the board state here.
    true.




% A simple evaluation function that counts the bot's contiguous marbles
evaluate_board(Board, Score) :-
    % You need to implement your evaluation logic based on the board state here.
    true.

% This would be where you actually define what a possible move is
possible_move(Hexagon, Direction, NumberOfSpins) :-
    between(1, 7, Hexagon),
    member(Direction, [c, cc]),
    between(1, 5, NumberOfSpins).

random_in_range(Low, High, Result) :- %calculates a number in float format, and then escales when the function is called (1-5)
    random(RandomFloat),
    Result is round(Low + RandomFloat * (High - Low)).

game_type:-  
    write('Please select game mode:\n'),
    write('1 - Human vs. Human\n'),
    write('2 - Human vs. Bot\n'),
    write('3 - Bot vs. Bot\n'),
    read_game_option(PlayChoice),
    (   PlayChoice = 2 -> select_bot_difficulty;
        PlayChoice = 3 -> select_bot_vs_bot_difficulty;
        process_play_choice(PlayChoice)
    ).

select_bot_difficulty :-
    write('Select Bot Difficulty:\n'),
    write('1 - Random Bot\n'),
    write('2 - Greedy Bot\n'),
    read_bot_difficulty(BotDifficulty),
    process_bot_difficulty_choice(BotDifficulty).

read_bot_difficulty(BotDifficulty) :-
    write('Enter your choice (1 or 2): '),
    read(BotDifficulty),
    validate_bot_difficulty(BotDifficulty).

validate_bot_difficulty(BotDifficulty) :-
    (BotDifficulty = 1 ; BotDifficulty = 2),
    !.

validate_bot_difficulty(_) :-
    write('Invalid difficulty. Please try again.\n'),
    select_bot_difficulty.

process_bot_difficulty_choice(1) :-
    set_bot_type(random),
    game_loop_human_vs_bot.

process_bot_difficulty_choice(2) :-
    set_bot_type(greedy),
    game_loop_human_vs_bot.

select_bot_vs_bot_difficulty :-
    write('Select Difficulty for Both Bots:\n'),
    write('1 - Random vs Random\n'),
    write('2 - Greedy vs Greedy\n'),
    write('3 - Random vs Greedy\n'),
    read_bot_vs_bot_difficulty(BotVsBotDifficulty),
    process_bot_vs_bot_difficulty_choice(BotVsBotDifficulty).

read_bot_vs_bot_difficulty(BotVsBotDifficulty) :-
    write('Enter your choice (1, 2, or 3): '),
    read(BotVsBotDifficulty),
    validate_bot_vs_bot_difficulty(BotVsBotDifficulty).

validate_bot_vs_bot_difficulty(BotVsBotDifficulty) :-
    (BotVsBotDifficulty = 1 ; BotVsBotDifficulty = 2 ; BotVsBotDifficulty = 3),
    !.

validate_bot_vs_bot_difficulty(_) :-
    write('Invalid difficulty. Please try again.\n'),
    select_bot_vs_bot_difficulty.

% Process the chosen bot vs bot difficulty
process_bot_vs_bot_difficulty_choice(1) :-
    set_bot_type(random, random),
    game_loop_bot_vs_bot.

process_bot_vs_bot_difficulty_choice(2) :-
    set_bot_type(greedy, greedy),
    game_loop_bot_vs_bot.

process_bot_vs_bot_difficulty_choice(3) :-
    set_bot_type(random, greedy),
    game_loop_bot_vs_bot.

% Set the bot type for a single bot
set_bot_type(Type) :-
    retractall(bot_type(_)),
    assert(bot_type(Type)).

% Set the bot type for bot vs bot
set_bot_type(Type1, Type2) :-
    retractall(bot_type(_,_)),
    assert(bot_type(bot1, Type1)),
    assert(bot_type(bot2, Type2)).

    

game_loop_human_vs_human :-
    clear_console,
    print_board,

    % Player 1's turn
    write('Player 1\'s turn:\n'),
    prompt_for_hexagon_and_direction(Hexagon1, Direction1, Spins1),
    ( Direction1 = exit -> true ;
      repeat_spin(Hexagon1, Direction1, Spins1),
      clear_console,
      print_board,

      % Player 2's turn
      write('Player 2\'s turn:\n'),
      prompt_for_hexagon_and_direction(Hexagon2, Direction2, Spins2),
      ( Direction2 = exit -> true ;
        repeat_spin(Hexagon2, Direction2, Spins2),
        clear_console,
        print_board,
        game_loop_human_vs_human )).

repeat_spin(_, _, 0).
repeat_spin(Hexagon, Direction, Spins) :-
    Spins > 0,
    handle_action(Hexagon, Direction),
    NewSpins is Spins - 1,
    repeat_spin(Hexagon, Direction, NewSpins).

game_loop_human_vs_bot :-
    clear_console,
    print_board,
    write('Your turn:\n'),
    
    % User Turn
    prompt_for_hexagon_and_direction(Hexagon, Direction, NumberOfSpins),
    ( Direction = exit -> true ; 
      repeat_spin(Hexagon, Direction, NumberOfSpins),
      clear_console,
      print_board,

      % Bot Turn
      write('Bot\'s turn:\n'),
      bot_move('Bot', BotHexagon, BotDirection, BotNumberOfSpins),
      %display_bot_move('Bot', BotHexagon, BotDirection, BotNumberOfSpins),
      sleep(4),
      repeat_spin(BotHexagon, BotDirection, BotNumberOfSpins),
      clear_console,
      print_board,
      
      game_loop_human_vs_bot ).




game_loop_bot_vs_bot :-
    clear_console,
    print_board,
    
    % Bot 1's move
    bot_move('Bot 1', Hexagon1, Direction1, Spins1),
    repeat_spin(Hexagon1, Direction1, Spins1),
    sleep(4),
    clear_console,
    print_board,

    % Bot 2's move
    bot_move('Bot 2', Hexagon2, Direction2, Spins2),
    repeat_spin(Hexagon2, Direction2, Spins2),
    sleep(4),
    clear_console,
    print_board,

    game_loop_bot_vs_bot.



display_bot_move(BotName, Hexagon, Direction, NumberOfSpins) :-
    write(BotName), write(' chose hexagon: '), write(Hexagon), nl,
    write(BotName), write(' chose direction: '), write(Direction), nl,
    write(BotName), write(' will spin the hexagon '), write(NumberOfSpins), write(' times.'), nl.


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

invalid_input :-
    write('Invalid input. Please try again.'), nl.


