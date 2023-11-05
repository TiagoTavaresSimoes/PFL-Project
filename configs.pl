:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(between)).
:- consult('board.pl').
:- consult('menu.pl').

% other_player(+Player, -OtherPlayer)
% Determines the opposite player based on the current player.
other_player(player1, player2).
other_player(player2, player1).

% flugelrad/0
flugelrad:-
    write('--------------------------------------\n'),
    write('      Welcome to Flugelrad!           \n'),
    write('--------------------------------------\n\n').

% game_loop/0
% Handles the main game loop, processing turns until the game is exited or a winner is declared.
game_loop :-
    clear_console,
    print_board,
    (   game_mode(bot_vs_bot) ->
            bot_move(Hexagon, Direction, NumberOfSpins),
            format('Bot chose hexagon number ~w, played ~w, and spun the wheel ~w times~n', [Hexagon,Direction,NumberOfSpins]),
            flush_output
        ;   prompt_for_hexagon_and_direction(Hexagon, Direction, NumberOfSpins)
    ),
    (   Direction = exit ->
            writeln('Game has been exited.'),
            true  % Terminate the loop if the player chose to exit.
        ;   handle_action(Hexagon, Direction, NumberOfSpins), % Apply the chosen move.
            (   winner_exists -> % After the move is handled, check for a winner.
                    writeln('We have a winner!'),
                    print_board, % Show the final state of the board.
                    display_winner_message % Display a message with the winner details.
                ;   game_loop % If there is no winner, continue the loop.
            )
    ).


% prompt_for_hexagon_and_direction(-Hexagon, -Direction, -NumberOfSpins)
% Prompts the user for a hexagon number, direction of rotation, and number of spins.
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


% prompt_for_direction(-Direction)
% Prompts the user for the direction of rotation.
prompt_for_direction(Direction) :-
    write('Rotate clockwise or counterclockwise? (c/cc): '),
    read(TempDirection),
    ( 
        (TempDirection = c ; TempDirection = cc) -> Direction = TempDirection
        ;
        write('Invalid input. Please enter c or cc.'), nl,
        prompt_for_direction(Direction)
    ).


% prompt_for_spin_count(-NumberOfSpins)
% Prompts the user for how many times they want to spin the wheel.
prompt_for_spin_count(NumberOfSpins) :-
    write('How many times do you want to spin the wheel (1-5)? '),
    read(TempNumberOfSpins),
    ( 
        integer(TempNumberOfSpins), between(1, 5, TempNumberOfSpins) -> NumberOfSpins = TempNumberOfSpins
        ;
        write('Invalid input. Please enter a number between 1 and 5.'), nl,
        prompt_for_spin_count(NumberOfSpins)
    ).

% handle_action(+Hexagon, +Direction)
% Executes the action for the given hexagon and direction.
handle_action(_, exit). 
handle_action(Hexagon, Direction) :-
    (Direction = c -> rotate_hexagon_clockwise(Hexagon) ;
     Direction = cc -> rotate_hexagon_counterclockwise(Hexagon)),
    synchronize_neighbors(Hexagon).


% bot_move(+BotName, -Hexagon, -Direction, -NumberOfSpins)
% Determines a bot move with a randomly chosen hexagon, direction, and number of spins.
bot_move(BotName, Hexagon, Direction, NumberOfSpins) :-
    sleep(1),
    % Choose a random hexagon (1-7)
    random(RandomFloat),
    Hexagon is round(1 + RandomFloat * (7 - 1)),
    random_member(Direction, [c, cc]),
    % Randomly choose how many times to spin the hexagon (ex: 1-5 times for this example)
    random_in_range(1, 5, NumberOfSpins),
    display_bot_move(BotName, Hexagon, Direction, NumberOfSpins).


% max_depth(-Depth)
% Defines the maximum depth for the minimax algorithm.
max_depth(Depth) :- Depth is 3.


% greedy_bot_move(+Board, -BestHexagon, -BestDirection, -BestNumberOfSpins)
% Chooses a move based on a greedy algorithm (minimax) evaluating the best score.
greedy_bot_move(Board, BestHexagon, BestDirection, BestNumberOfSpins) :-
    max_depth(Depth),
    minimax(Board, Depth, BestHexagon, BestDirection, BestNumberOfSpins, _Score).


% minimax(+Board, +Depth, -Hexagon, -Direction, -NumberOfSpins, -Score)
% The minimax algorithm that evaluates the best move and its score up to a given depth.
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


% is_maximizing_player(+Board)
% Determines if the current player is the maximizing player.
is_maximizing_player(Board) :-
    % Implement the logic to determine if it's the maximizing player's (bot's) turn.
    % For simplicity, this example assumes it's always the bot's turn when minimax is called.
    true.


% apply_move(+Board, +Hexagon, +Direction, +NumberOfSpins, -NewBoard)
% Applies a move to the board and returns the new board state.
apply_move(Board, Hexagon, Direction, NumberOfSpins, NewBoard) :-
    % You need to implement the logic to mutate the board state here.
    true.


% evaluate_board(+Board, -Score)
% Evaluates the board and assigns a score based on the current state.
evaluate_board(Board, Score) :-
    % You need to implement your evaluation logic based on the board state here.
    true.


% possible_move(-Hexagon, -Direction, -NumberOfSpins)
% Generates all possible moves given the current board state.
possible_move(Hexagon, Direction, NumberOfSpins) :-
    between(1, 7, Hexagon),
    member(Direction, [c, cc]),
    between(1, 5, NumberOfSpins).

% random_in_range(+Low, +High, -Result)
% Generates a random number within the specified range.
random_in_range(Low, High, Result) :- %calculates a number in float format, and then escales when the function is called (1-5)
    random(RandomFloat),
    Result is round(Low + RandomFloat * (High - Low)).



% set_bot_type(+Type1, +Type2)
% Sets the type for each bot in a bot vs bot game.
set_bot_type(Type1, Type2) :-
    retractall(bot_type(_,_)),
    assert(bot_type(bot1, Type1)),
    assert(bot_type(bot2, Type2)).

    
% game_loop_human_vs_human/0
% Handles the game loop for a human vs human match.
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

% repeat_spin(+Hexagon, +Direction, +Spins)
% Repeats a spin action for a given number of times.
repeat_spin(_, _, 0).
repeat_spin(Hexagon, Direction, Spins) :-
    Spins > 0,
    handle_action(Hexagon, Direction),
    NewSpins is Spins - 1,
    repeat_spin(Hexagon, Direction, NewSpins).


% game_loop_human_vs_bot/0
% Handles the game loop for a human vs bot match.
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



% game_loop_bot_vs_bot/0
% Handles the game loop for a bot vs bot match.
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


% display_bot_move(+BotName, +Hexagon, +Direction, +NumberOfSpins)
% Displays the move chosen by a bot.
display_bot_move(BotName, Hexagon, Direction, NumberOfSpins) :-
    write(BotName), write(' chose hexagon: '), write(Hexagon), nl,
    write(BotName), write(' chose direction: '), write(Direction), nl,
    write(BotName), write(' will spin the hexagon '), write(NumberOfSpins), write(' times.'), nl.

% read_game_option(-PlayChoice)
% Reads the player's game mode choice.
read_game_option(PlayChoice) :-
    write('Enter your choice (1, 2, or 3): '),
    read(PlayChoice),
    validate_choice(PlayChoice).

% process_play_choice(+Choice)
% Processes the player's game mode choice and starts the corresponding game loop.
process_play_choice(1) :-
    game_loop_human_vs_human.

process_play_choice(2) :-
    game_loop_human_vs_bot.

process_play_choice(3) :-
    game_loop_bot_vs_bot.

process_play_choice(_) :-
    write('Invalid play mode. Please try again.\n'),
    game_type.


% gamestate(-GameState)
% Initializes the game state with the main menu, clears the board and starts a new game.
gamestate([Board, player1, 0]) :-
    main_menu,
    clear_console,
    title,
    initial_board(Board), print_board(Board).

invalid_input :-
    write('Invalid input. Please try again.'), nl.


