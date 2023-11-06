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

