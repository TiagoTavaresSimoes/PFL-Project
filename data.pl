% data.pl

% Game modes
game_mode(human_vs_human).
game_mode(human_vs_bot).
game_mode(bot_vs_bot).

% Bot difficulty levels
bot_difficulty(easy).
bot_difficulty(medium).
bot_difficulty(hard).

% Players and their associated colors
player(player1, blue).
player(player2, green).

% Menu and game header
game_header('======= Hexagonal Marble Game =======').
menu([
    '1. Human vs. Human',
    '2. Human vs. Bot',
    '3. Bot vs. Bot',
    '4. Exit'
]).

% The impeller wheel's default position
default_wheel_position(wheel).

