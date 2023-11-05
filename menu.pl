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