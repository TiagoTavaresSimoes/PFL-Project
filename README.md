# Turma 2 - Flügelrad

## Trabalho realizado por:
- <b>Tiago Tavares Simões</b> up202108857
- <b>Diogo Carvalho Pintado</b> up202108875

## Grade:
17.55/20.00

## Instalação e Execução:

### Windows

- Para proceder à instalação do nosso jogo no sistema operativo <b>Windows</b> é necessário:
- Download e Executar o programa <b>`SicStus Prolog`</b>
- `File` -> `Consult...` -> Selecionar ficheiro `main.pl`
- Na consola digitar `play.`

### Linux
- Para proceder à instalação do nosso jogo no sistema operativo <b>Linux</b> é necessário:
- Executar o programa <b>`SicStus Prolog`</b>
- `File` -> `Consult...` -> Selecionar ficheiro `main.pl`
- Na consola digitar `play.`

## Descrição do Jogo:

O tabuleiro de jogo consiste em sete espaços hexagonais, cada um com um orifício no seu centro para colocar a 'wheel'. O jogo é jogado com berlindes, sendo estas de cores verde e azul. Cada jogador tem a sua própria cor. 

Cada jogador, na sua vez de jogar, reposiciona a 'wheel' e depois gira-a tanto quanto quiser, movendo assim até seis berlindes ao mesmo tempo. 

O primeiro jogador a formar uma sequência de pelo menos 6 berlindes seguidos ganha o jogo. Mas lembrando que cada jogador consegue mover facilmente os berlindes do adversário, pois bastam estas estarem dentro do espaço hexagonal. Basta uma jogada inteligente para dificultar a vida do oponente.

## Lógica do Jogo:
### Representação Interna do Estado de Jogo
#### Tabuleiro
O tabuleiro é representado por um conjunto de hexágonos, onde cada hexágono contém uma lista de posições que podem ser ocupadas por berlindes. Cada posição dentro de um hexágono pode ter um dos seguintes valores:
- `'G'` para um berlinde verde
- `'B'` para um berlinde azul
- `'X'` para uma posição vazia

O tabuleiro é composto por 7 hexágonos, cada um identificado por um número único. O estado do jogo é mantido dinamicamente e pode ser alterado através de rotações dos hexágonos, no sentido horário ou anti-horário, e por sincronização das peças entre hexágonos adjacentes.

```prolog
rotate_hexagon_counterclockwise(N) :-
    hexagon(N, Marbles),
    reverse(Marbles, [Last|RevRest]),
    reverse(RevRest, NewMarblesStart),
    append([Last], NewMarblesStart, RotatedMarbles),
    retract(hexagon(N, Marbles)),  
    asserta(hexagon(N, RotatedMarbles)),  
    synchronize_neighbors(N).

rotate_hexagon_clockwise(N) :-
    hexagon(N, Marbles),
    rotate_once_clockwise(Marbles, RotatedMarbles),
    retract(hexagon(N, Marbles)),
    asserta(hexagon(N, RotatedMarbles)),
    synchronize_neighbors(N).
```
_Retirado de `board.pl`_

```prolog
Possiveis estados de jogo:

- Estado Inicial:
Hexagon 1: ['G', 'B', 'X', 'X', 'X', 'B']
Hexagon 2: ['G', 'B', 'G', 'X', 'X', 'X']
Hexagon 3: ['G', 'X', 'X', 'X', 'G', 'B']
Hexagon 4: ['X', 'X', 'X', 'X', 'X', 'X']
Hexagon 5: ['X', 'B', 'G', 'B', 'X', 'X']
Hexagon 6: ['X', 'X', 'X', 'B', 'G', 'B']
Hexagon 7: ['X', 'X', 'G', 'B', 'G', 'X']

- Estado Intermédio:
Hexagon 1: ['X', 'X', 'X', 'B', 'G', 'B']
Hexagon 2: ['G', 'B', 'G', 'X', 'X', 'X']
Hexagon 3: ['X', 'G', 'B', 'X', 'G', 'X']
Hexagon 4: ['B', 'X', 'B', 'G', 'B', 'B']
Hexagon 5: ['X', 'X', 'X', 'X', 'G', 'B']
Hexagon 6: ['X', 'B', 'X', 'X', 'G', 'X']
Hexagon 7: ['G', 'G', 'B', 'G', 'G', 'X']

- Estado Final:
Hexagon 1: ['B', 'B', 'X', 'X', 'G', 'G']
Hexagon 2: ['X', 'B', 'X', 'X', 'B', 'X']
Hexagon 3: ['X', 'G', 'G', 'B', 'X', 'X']
Hexagon 4: ['X', 'B', 'X', 'B', 'G', 'G']
Hexagon 5: ['X', 'X', 'X', 'X', 'G', 'X']
Hexagon 6: ['B', 'G', 'G', 'B', 'G', 'B']
Hexagon 7: ['B', 'G', 'B', 'G', 'G', 'G']
```
_Retirado de `board.pl`_

#### Player
O player pode ser dividido em dois estados possíveis: `Player 1` e `Player 2`.

```prolog
% other_player(+Player, -OtherPlayer)
% Determines the opposite player based on the current player.
other_player(player1, player2).
other_player(player2, player1).
```
_Retirado de `configs.pl`_

Cada jogador, se tiver a defrontar outro jogador, tem direto de escolher a cor do berlinde que pretende, sendo esta azul (`B`) ou verde (`G`).

```prolog
ask_player_color(PlayerNumber, AlreadyChosenColors, Color) :-
    format('Player ~w, please select your marble color (B for Blue/G for Green): ', [PlayerNumber]),
    read(TempColor),
    validate_player_color(PlayerNumber, TempColor, AlreadyChosenColors, Color).

validate_player_color(_, Color, AlreadyChosenColors, Color) :-
    memberchk(Color, [b,g]), % Check if the color is either b or g
    \+ member(Color, AlreadyChosenColors), % Ensure color has not been chosen already
    !.
validate_player_color(PlayerNumber, _, AlreadyChosenColors, Color) :-
    write('Invalid color or color already chosen. Please enter B for Blue or G for Green.\n'),
    ask_player_color(PlayerNumber, AlreadyChosenColors, Color).

process_play_choice(1) :-
    ask_player_color(1, [], Player1Color),
    ask_player_color(2, [Player1Color], Player2Color), % Pass Player1Color as already chosen
    write('Player 1 has chosen '), write_color(Player1Color), nl,
    write('Player 2 has chosen '), write_color(Player2Color), nl,
    sleep(2),
    game_loop_human_vs_human(Player1Color, Player2Color).

write_color(b) :- write('Blue').
write_color(g) :- write('Green').

```
_Retirado de `menu.pl`_

### Visualização do Estado do Jogo

#### Após iniciar o jogo com o predicado `play.` o jogador visualisará um menu inicial com as opções principais do jogo:

```prolog
--------------------------------------
      Welcome to Flugelrad!           
--------------------------------------

Main Menu
1. Play Game
2. Help
3. Leave Game
Enter your choice (1, 2, or 3)
```
_Retirado de `menu.pl`_

#### <b>Ao selecionarmos a primeira opção do menu, redirecionamos para uma página relacionada ao modo de jogo possível de jogar.</b>

```prolog

Please select game mode:
1 - Human vs. Human
2 - Human vs. Bot
3 - Bot vs. Bot

Enter your choice (1, 2, or 3): |: 
```
_Retirado de `menu.pl`_

- Ao selecionar a primeira opção, somos perguntados pela cor que o `player 1` gostaria de assumir.
- Ao selecionar a segunda opção, teremos de escolher a dificuldade do bot, sendo esta <b>Random</b>, composto por jogadas aleatórias ou <b>Greedy</b>, composto pela análise de jogadas mais favoráveis.
- Ao selecionar a terceira opção, teremos de escolher a dificuldade dos dois bots, sendo o jogo definido por bots <b>Random vs Random</b>, <b>Random vs Greedy</b> ou <b>Greedy vs Greedy</b>
    
```prolog
Select Difficulty for Both Bots:
1 - Random vs Random
2 - Greedy vs Greedy
3 - Random vs Greedy
Enter your choice (1, 2, or 3): |
```
_Retirado de `menu.pl`_

- Assim que o jogo é iniciado é apresentado o tabuleiro no seguinte formato:

```prolog
             / G \ 
            B     B
       / G \|     |/ G \ 
      B     X     X     B
      |     |\ X /|     |
      G     X     X     G
       \ X /|     |\ X /
       B    X     X    B 
       |    |\ X /|    |
       G    X     X    G 
       \ B /|     |\ B /
            G     G
             \ B /
```
_Retirado de `board.pl`_

- E apresenta um texto a referir de quem é a vez de jogar, claro, dependendo do modo do jogo, pois quando o bot joga, automaticamente refere a jogada que o bot realizou.

#### <b>Ao selecionarmos a segunda opção do menu, redirecionamos para uma página relacionada com a ajuda necessária para o utilizador entender bem o conceito do jogo.</b>

```prolog

       Flugelrad Game Guide       
==================================

Flugelrad is a strategy board game involving marbles and an impeller wheel. Dive into the key rules and strategies:

When two players turn the wheel, this can be quite constructive, at least if they play a game of Flugelrad.
The game board consists of seven hexagonal spaces, each of which has a hole in its center for the impeller wheel.
The game is played with marbles; each player has their own color.
On your turn, you reposition the impeller wheel, then rotate it as far as you like, thus moving up to six marbles at the same time.
The first player to form a contiguous cluster of at least six of their marbles wins.
But beware since you can easily move your opponents marbles as well.
-----------------------------------------------------------------------------------------------------------------------------------

1. Return to Main Menu
2. Leave Game
Enter your choice (1 or 2): |:
```
_Retirado de `menu.pl`_

- Ao clicar na opção 1 desse menu de ajuda, o utilizador será redirecionado de novo para o menu principal

#### <b>Ao selecionarmos a terceira opção do menu, sairemos do jogo.</b>


### Execução de Jogadas

No caso do nosso jogo, cada usuário basta ir jogando, o jogo só termina quando a winning condition se satisfazer

Temos o exemplo deste loop de um dos modos de jogo, este loop já basta até se criar a winning condition.

```prolog
game_loop_human_vs_human(Player1Color, Player2Color) :-
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
        game_loop_human_vs_human(Player1Color, Player2Color) )).
```
_Retirado de `configs.pl`_

Assim como estas duas funções de movimento. A função `move(Board, Hexagon, Direction, NumberOfSpins, NewBoard)` que aplica um move no jogo e retorna um quadro atualizado.

```prolog
move(Board, Hexagon, Direction, NumberOfSpins, NewBoard) :-
    % You need to implement the logic to mutate the board state here.
    true.
```
_Retirado de `configs.pl`_



### Lista de Jogadas Válidas

O nosso mecanismo para encontrar todas as jogadas válidas é a função `valid_moves(Hexagon, Direction, NumberOfSpins)`.

```prolog
valid_moves(Hexagon, Direction, NumberOfSpins) :-
    between(1, 7, Hexagon),
    member(Direction, [c, cc]),
    between(1, 5, NumberOfSpins).
```
_Retirado de `configs.pl`_

Decidimos apenas utilizar esta função para avaliar o movimento dos bots, por motivos de eficiência temporal.

### Avaliação do Tabuleiro

Neste jogo, o cálculo do `value` de cada jogada foi efetuado a partir de um algoritmo auxiliar chamado `minimax`, cuja definição irei colocar mais abaixo.

### Final de jogo

Quando a winning condition se satisfazer, o jogo termina. A verificação dada é a partir da função `game_over`:

```prolog
game_over :-
    hexagon(Hexagon, Marbles),
    nth1(Position, Marbles, Marble),
    Marble \= 'X',  % Exclude empty marbles
    dfs(Hexagon, Position, Marble, 1, [], _WinningPath),
    !.  % Cut to stop searching further when a winning sequence is found
```
_Retirado de `board.pl`_

### Jogada do Computador

Para os bots decidirem qual movimento realizar, foram realizados dois métodos: <b>random</b> e <b>greedy</b>.

O método <b>random</b> apenas escolhe de forma aleatória um movimento da lista de movimentos válidos.

```prolog
% choose_move(+BotName, -Hexagon, -Direction, -NumberOfSpins)
% Determines a bot move with a randomly chosen hexagon, direction, and number of spins.
choose_move(BotName, Hexagon, Direction, NumberOfSpins) :-
    sleep(1),
    % Choose a random hexagon (1-7)
    random(RandomFloat),
    Hexagon is round(1 + RandomFloat * (7 - 1)),
    random_member(Direction, [c, cc]),
    % Randomly choose how many times to spin the hexagon (ex: 1-5 times for this example)
    random_in_range(1, 5, NumberOfSpins),
    display_bot_move(BotName, Hexagon, Direction, NumberOfSpins).

```
_Retirado de `configs.pl`_

O método <b>greedy</b> foi implementado com o auxílio do algoritmo `minimax`, que avalia todos os movimentos possíveis e escolhe o mais vantajoso.

```prolog
% minimax(+Board, +Depth, -Hexagon, -Direction, -NumberOfSpins, -Score)
% The minimax algorithm that evaluates the best move and its score up to a given depth.
minimax(Board, Depth, Hexagon, Direction, NumberOfSpins, Score) :-
    ( Depth =< 0 ->
        evaluate_board(Board, Score) % If we have reached the maximum depth, evaluate the board
    ; otherwise ->
        findall(
            [H, D, NS, S],
            ( valid_moves(H, D, NS), % For all possible moves
              move(Board, H, D, NS, NewBoard), % Apply the move
              minimax(NewBoard, Depth - 1, _, _, _, S) % Recurse for the next depth
            ),
            MovesScores
        ),
        % Decide whether to maximize or minimize based on whose turn it is
        % if it's the bot's turn, we want to maximize the score.
        ( is_maximizing_player(Board) ->
            max_member([Hexagon, Direction, NumberOfSpins, Score], MovesScores)
        ; otherwise ->
            min_member([Hexagon, Direction, NumberOfSpins, Score], MovesScores)
        )
    ).
```
_Retirado de `configs.pl`_

```prolog
% max_depth(-Depth)
% Defines the maximum depth for the minimax algorithm.
max_depth(Depth) :- Depth is 3.
```
_Retirado de `configs.pl`_

- Quando a condição base é atingida (isto é, Depth =< 0), o algoritmo chama a função evaluate_board/2 para calcular o `Score` para a configuração atual do tabuleiro (Board).
- Se ainda não estiver na profundidade máxima, o algoritmo usa o predicativo `findall/3` para gerar uma lista de todos os movimentos possíveis e os scores associados.
- Cada chamada recursiva retorna um `Score`, e estas pontuações são acumuladas na lista `MovesScores`. Isso significa que o cálculo de Score para profundidades maiores que 0 ocorre quando a recursão atinge a condição base.
- O algoritmo seleciona o melhor movimento da lista `MovesScores`. Neste caso, na vez do bot, ele usa o predicativo `max_member/2` para encontrar o movimento com o maior `Score`.
- O algoritmo também calcula a jogada com o menor score, neste caso o `min_member/2`.

## Conclusões

Após a realização deste projeto, a nossa maior dificuldade foi na connstrução da tabela, pois esta tinha uma forma bastante peculiar, e também na definição da winning condition, o que nos baralhou bastante ao longo deste percurso.
Outro aspeto que posso realçar foi na implementação do minimax, pois o bot greedy necessitava de acesso a cada jogada possível e fazê-lo de maneira avantajada.


### Possíveis Melhorias
- Implementação da `winning condition`
- Representação das conexões da tabela.

## Bibliografia

- [Board Game Geek](https://boardgamegeek.com/boardgame/400097/flugelrad)
- [SICStus Prolog](https://sicstus.sics.se)
