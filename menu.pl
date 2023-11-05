% main_menu/0
% Displays the main menu and processes the user's choice.
main_menu :-
    clear_console,
    flugelrad,
    write('Main Menu\n'),
    write('1. Play Game\n'),
    write('2. Help\n'),
    write('3. Leave Game\n'),
    read_option(Choice),
    process_choice(Choice).

% help_menu/0
% Displays the help menu with game instructions and options to return or exit.
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

% read_help_option(-Choice)
% Reads the user's choice on the help menu and ensures it's valid.
read_help_option(Choice) :-
    write('Enter your choice (1 or 2): '),
    read(Choice),
    validate_help_choice(Choice).

% validate_help_choice(+Choice)
% Validates the user's choice on the help menu.
validate_help_choice(Choice) :-
    (Choice = 1 ; Choice = 2),
    !.

% process_help_choice(+Choice)
% Processes the user's choice on the help menu, directing to the main menu or exiting.
validate_help_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    read_help_option(Choice).

% process_help_choice(+Choice)
% Processes the user's choice on the help menu, directing to the main menu or exiting.
process_help_choice(1) :-
    main_menu.

% process_help_choice(2)
% Exits the game when the user chooses to leave from the help menu.
process_help_choice(2) :-
    write('Thanks for playing!\n'),
    halt.

% process_choice(+Choice)
% Directs to the help menu.
process_choice(2) :-
    help_menu.

% read_option(-Choice)
% Reads the user's choice on the main menu.
read_option(Choice) :-
    write('Enter your choice (1, 2, or 3): '),
    read(Choice),
    validate_choice(Choice).

% validate_choice(+Choice)
% Validates the user's choice on the main menu.
validate_choice(Choice) :-
    (Choice = 1 ; Choice = 2 ; Choice = 3),
    !.

validate_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    read_option(Choice).

% process_choice(1)
% Starts the process to determine the game type when the user chooses to play.
process_choice(1) :-
    game_type.

% process_choice(2)
% Leads to the help menu when the user requests help.
process_choice(2) :-
    help_menu.

% process_choice(3)
% Exits the game when the user chooses to leave from the main menu.
process_choice(3) :-
    write('Thanks for playing!\n'),
    halt.

% game_type/0
% Allows the user to select the game mode.
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


% ask_player_color(+PlayerNumber, -Color)
% Asks the given player for their choice of color and returns the selected color.
ask_player_color(PlayerNumber, Color) :-
    format('Player ~w, please select your marble color (B for Blue/G for Green): ', [PlayerNumber]),
    read(TempColor),
    validate_player_color(PlayerNumber, TempColor, Color).


% validate_player_color(+Input, -Color)
% Validates the color chosen by the player.
validate_player_color(_, Color, Color) :-
    Color = b; Color = g,
    !.
validate_player_color(PlayerNumber, _, Color) :-
    write('Invalid color. Please enter B for Blue or G for Green.\n'),
    ask_player_color(PlayerNumber, Color).

% This is part of your existing code where you need to integrate the color selection
process_play_choice(1) :-
    ask_player_color(1, Player1Color),
    ask_player_color(2, Player2Color),
    write('Player 1 has chosen '), write_color(Player1Color), nl,
    write('Player 2 has chosen '), write_color(Player2Color), nl,
    sleep(2),
    % Initialize the game loop with the chosen colors
    game_loop_human_vs_human(Player1Color, Player2Color).

% write_color(+Color)
% Writes the full name of the color based on the player's choice.
write_color(b) :- write('Blue').
write_color(g) :- write('Green').


% select_bot_difficulty/0
% Presents options to select the difficulty level of the bot for Human vs. Bot mode.
select_bot_difficulty :-
    write('Select Bot Difficulty:\n'),
    write('1 - Random Bot\n'),
    write('2 - Greedy Bot\n'),
    read_bot_difficulty(BotDifficulty),
    process_bot_difficulty_choice(BotDifficulty).

% read_bot_difficulty(-BotDifficulty)
% Reads the user's choice for the bot's difficulty level.
read_bot_difficulty(BotDifficulty) :-
    write('Enter your choice (1 or 2): '),
    read(BotDifficulty),
    validate_bot_difficulty(BotDifficulty).

% validate_bot_difficulty(+BotDifficulty)
% Validates the selected bot difficulty level.
validate_bot_difficulty(BotDifficulty) :-
    (BotDifficulty = 1 ; BotDifficulty = 2),
    !.


validate_bot_difficulty(_) :-
    write('Invalid difficulty. Please try again.\n'),
    select_bot_difficulty.

% process_bot_difficulty_choice(+BotDifficulty)
% Processes the chosen difficulty and initializes the Human vs. Bot game loop.
process_bot_difficulty_choice(1) :-
    set_bot_type(random),
    game_loop_human_vs_bot.

% process_bot_difficulty_choice(2)
% Sets the bot as greedy and starts the Human vs. Bot game loop.
process_bot_difficulty_choice(2) :-
    set_bot_type(greedy),
    game_loop_human_vs_bot.

% select_bot_vs_bot_difficulty/0
% Allows the user to select difficulty levels for Bot vs. Bot game mode.
select_bot_vs_bot_difficulty :-
    write('Select Difficulty for Both Bots:\n'),
    write('1 - Random vs Random\n'),
    write('2 - Greedy vs Greedy\n'),
    write('3 - Random vs Greedy\n'),
    read_bot_vs_bot_difficulty(BotVsBotDifficulty),
    process_bot_vs_bot_difficulty_choice(BotVsBotDifficulty).

% read_bot_vs_bot_difficulty(-BotVsBotDifficulty)
% Reads the user's choice for bot vs. bot difficulty levels.
read_bot_vs_bot_difficulty(BotVsBotDifficulty) :-
    write('Enter your choice (1, 2, or 3): '),
    read(BotVsBotDifficulty),
    validate_bot_vs_bot_difficulty(BotVsBotDifficulty).

% validate_bot_vs_bot_difficulty(+BotVsBotDifficulty)
% Validates the selected difficulty for bot vs. bot mode.
validate_bot_vs_bot_difficulty(BotVsBotDifficulty) :-
    (BotVsBotDifficulty = 1 ; BotVsBotDifficulty = 2 ; BotVsBotDifficulty = 3),
    !.

validate_bot_vs_bot_difficulty(_) :-
    write('Invalid difficulty. Please try again.\n'),
    select_bot_vs_bot_difficulty.


% process_bot_vs_bot_difficulty_choice(+BotVsBotDifficulty)
% Processes the chosen difficulties for both bots in Bot vs. Bot mode.
process_bot_vs_bot_difficulty_choice(1) :-
    set_bot_type(random, random),
    game_loop_bot_vs_bot.

% process_bot_vs_bot_difficulty_choice(2)
% Sets both bots as greedy and starts the Bot vs. Bot game loop.
process_bot_vs_bot_difficulty_choice(2) :-
    set_bot_type(greedy, greedy),
    game_loop_bot_vs_bot.

% process_bot_vs_bot_difficulty_choice(3)
% Sets one bot as random and the other as greedy, then starts the Bot vs. Bot game loop.
process_bot_vs_bot_difficulty_choice(3) :-
    set_bot_type(random, greedy),
    game_loop_bot_vs_bot.


% set_bot_type(+Type)
% Sets the type for a single bot in Human vs. Bot mode.
set_bot_type(Type) :-
    retractall(bot_type(_)),
    assert(bot_type(Type)).