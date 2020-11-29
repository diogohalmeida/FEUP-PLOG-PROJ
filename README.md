# PLOG - TP1

## Intermediate Report  - Gekitai

### T4_Gekitai3

| Name                            | Number    | E-Mail               |
| ------------------------------- | --------- | -------------------- |
| Diogo Henrique Pinto de Almeida | 201806630 | up201806630@fe.up.pt |
| Pedro Manuel Santos Queirós     | 201806329 | up201806329@fe.up.pt |



## The Game: Gekitai

### Game Description

Gekitai is a 2-player, 3-in-a-row game played on a 6x6 grid. Each player has eight black/red markers and takes turns placing them anywhere on any open cell on the board. 

<img src=".\img\board.png" alt="final" style="zoom: 100%;" />

### Rules

When placed, a marker pushes all adjacent pieces outwards one space if there are open cells for them to move to. These adjacent pieces can also be pushed off if they're sitting on the edge of the board.

If there is not an open space on the opposite side of a pushed piece, it does not get pushed (a newly played piece cannot push two or more other lined-up pieces).

<img src=".\img\repel.png" alt="final" style="zoom: 100%;" />



 If a piece is shoved off of the board it is returned to the respective player.

<img src=".\img\push.png" alt="final" style="zoom: 100%;" />



The first player to either line up three of their colored pieces in a row at the end of their turn (after pushing) OR have all eight of their markers on the board (also after pushing) wins the game.

<img src=".\img\3row.png" alt="final" style="zoom: 100%;" />

[Source](https://boardgamegeek.com/boardgame/295449/gekitail) | [Rules](https://s3.amazonaws.com/geekdo-files.com/bgg260437?response-content-disposition=inline%3B%20filename%3D%22Gekitai_Rules.pdf%22&response-content-type=application%2Fpdf&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJYFNCT7FKCE4O6TA%2F20201101%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201101T160735Z&X-Amz-SignedHeaders=host&X-Amz-Expires=120&X-Amz-Signature=7e76faaaf75b807f90a3a36f4bf395bb78425eee24dce48029893d8f5643cd33)



## Game Logic

### Game State Representation

#### Board

For the board representation we used lists within a list (a matrix). This proved to be the most efficient way to represent both rows and columns. For the pieces and their illustration, we used 3 integers: a 0 represents an empty space, with the Black and Red Players being represented by 1's and 2's, respectively. Below is the representation of a few example boards:

- Initial Situation

```
[
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0]
]
```
- Intermediate Situation

```
[
[1,2,0,0,0,0],
[0,0,1,0,0,2],
[0,2,0,1,0,0],
[0,0,0,0,0,0],
[0,1,1,2,0,0],
[0,0,0,0,0,2]
].
```

- Final Situation

```
[
[1,2,0,0,0,0],
[0,0,1,0,0,2],
[0,2,0,1,0,0],
[0,0,0,0,1,0],
[0,1,1,0,0,0],
[0,0,2,0,0,2]
].
```


#### Player / Player Turn

To acknowledge which player is supposed to play in a turn, we have an atom "state" that records the next player to move, this state is updated every game loop iteration, alternating between players 1 (Blacks) and 2 (Reds).

To identify the computer difficulties we also use the atoms b1 (Easy Difficulty) and b2 (Hard Difficulty).

#### Game Loop

In Gekitai, the Black Pieces Player starts first, positioning his piece in whatever cell he wants on the initially empty board. The Red Player then proceeds with his play. This Black-Red loop keeps going until the end of the game.

Therefore, the gameloop is processed the following way: 

1. Initially assert that the Black Player (1) goes first;
2. Enter the loop section, retrieving the current player for this turn;
3. Call the "play" predicate, passing it the player for the turn;
4. Receive from the "play" predicate the next player and updating the state atom;
5. At the end of loop, check if the game is over (3-in-a-row or 8 placed pieces):
   - **If it isn't**, go back to Step 2.
   - **If it is**, end the game and print the result.



### Game State Visualization

#### Board

##### Visualization - [display.pl](./src/display.pl)

For the board pieces display, the values **0** (empty board), **1** (black player), **2** (red player) were replaced with symbols **' '**, **X** and **O**, respectively. These replacements were processed by the predicate ``print_symbol(Value, S)`` that checks the value (0, 1 or 2) and correctly assigns the correct symbol to S for it to be printed later on in ``print_element(X)``. 

The full board is displayed by the predicate ``print_board(X)``, that prints the header of the board and then calls ``print_matrix()``, that is in charge of printing each line and its separators recursively until it reaches its base case (``print_matrix([], 6)``).

Below are the visualizations for the game states showed in the previous section:

- Initial Situation

```
   | A | B | C | D | E | F |
---|---|---|---|---|---|---|
1  |   |   |   |   |   |   |
---|---|---|---|---|---|---|
2  |   |   |   |   |   |   |
---|---|---|---|---|---|---|
3  |   |   |   |   |   |   |
---|---|---|---|---|---|---|
4  |   |   |   |   |   |   |
---|---|---|---|---|---|---|
5  |   |   |   |   |   |   |
---|---|---|---|---|---|---|
6  |   |   |   |   |   |   |
---|---|---|---|---|---|---|
```

- Intermediate Situation

```
   | A | B | C | D | E | F |
---|---|---|---|---|---|---|
1  | X | O |   |   |   |   |
---|---|---|---|---|---|---|
2  |   |   | X |   |   | O |
---|---|---|---|---|---|---|
3  |   | O |   | X |   |   |
---|---|---|---|---|---|---|
4  |   |   |   |   |   |   |
---|---|---|---|---|---|---|
5  |   | X | X | O |   |   |
---|---|---|---|---|---|---|
6  |   |   |   |   |   | O |
---|---|---|---|---|---|---|
```

- Final Situation

```
   | A | B | C | D | E | F |
---|---|---|---|---|---|---|
1  | X | O |   |   |   |   |
---|---|---|---|---|---|---|
2  |   |   | X |   |   | O |
---|---|---|---|---|---|---|
3  |   | O |   | X |   |   |
---|---|---|---|---|---|---|
4  |   |   |   |   | X |   |
---|---|---|---|---|---|---|
5  |   | X | X |   |   |   |
---|---|---|---|---|---|---|
6  |   |   | O |   |   | O |
---|---|---|---|---|---|---|
```


##### Input Validation - [input.pl](./src/input.pl)

During the game, each player is prompted to play in their turn by a message that asks for the column and row (``readRow(CheckedRow)`` and ``readColumn(CheckedColumn)``). The input is then analyzed by the predicates ``checkRow(Row, CheckedRow)`` and ``checkColumn(Column, CheckedColumn)``, that correctly assign the code input in the console to a row or column number and check if the move is within the limits of the board. If the move inserted is invalid, the player is prompted to input a valid one.

- Invalid Row or Column - User inputs an out of bounds Row or Column

  <img src=".\img\invalid_column.png" alt="final" style="zoom: 100%;" />

<img src=".\img\invalid_row.png" alt="final" style="zoom: 100%;" />

#### Menus

##### Visualization - [display.pl](./src/display.pl)

After starting the program the user is presented with the main menu, where they can select which game mode they want to play:

1. Player vs Player

2. Player vs Computer

3. Computer vs Computer

   <img src=".\img\menu.png" alt="final" style="zoom: 100%;" />

If the user selects **Player vs Computer** or **Computer vs Computer**, it takes them to another menu, where they can select the Computer's difficulty settings

<img src=".\img\difficulty_menu.png" alt="final" style="zoom: 100%;" />

These menus are printed by the predicates ``printMainMenu`` and ``printSecondaryMenu`` .

##### Input Validation - [input.pl](./src/input.pl)

In the menus, input validation is assured by the predicates ``checkMenuOption(Option)`` and ``checkSecondaryMenuOption(Option)`` that are called after the input is read. These predicates fail if the input is not a valid menu option or if the input exceeds the number of menu options of that menu, prompting the user again to input a valid option. If, however, the input is valid, then the option is passed to one of the "run" predicates (``runOption(Option)``, ``runPlayerVComputerOption(Option)`` or ``runComputerVComputerOption(Option)`` depending on the menu),  that start the correct game loop.

<img src=".\img\invalid_menu.png" alt="final" style="zoom: 100%;" />



### List of Valid Moves - [utils.pl](./src/utils.pl)

To obtain the list of all possible moves for the current board state and player we implemented the predicate ``valid_moves(GameState,Player,ListOfMoves)``.  This predicate uses the built-in predicate ``findall(Template, Goal, Bag)`` to get all the solutions for the auxiliary predicate ``possibleMove(Player,Board,Row,Column,UpdatedBoard)``.

The ``possibleMove(Player,Board,Row,Column,UpdatedBoard)`` predicate iterates through all the board positions with ``newPosition(1,1,Row,Column)`` and checks if the move is valid using ``valid(Player,Column, Row, Board, UpdatedBoard)``.

We utilize this module for the AI section of the code, so the program can evaluate which move is suitable for the currently selected difficulty.

### Move Execution - [input.pl](./src/input.pl)

The predicate ``move(GameState,Move,NewGameState)`` handles all the player move processing during the game.  

Initially, the program gets both the row and column of the desired move and determines the content of that board cell. This content is later used in the ``checkOccupied(Column, Row, GameState)`` predicate, that, in addition to the input validation described in the previous section, checks if the desired cell is already occupied by a piece.  If it is ocuppied, then the predicate fails and the user is prompted to input another move. 

After the move is validated, the predicate ``putPiece(GameState, Row, Column, Player, UpdatedBoard)`` finds the desired position and places the player's piece there. 

Finally, the ``repulsion(Row, Column, UpdatedBoard,NewGameState)``  predicate is called. This predicate handles all the repulsions done to adjacent pieces after a move is done.

### End Game State - [logic.pl](./src/logic.pl)

Every game loop iteration, the ``game_over(Board,Winner)`` predicate is called, it analyzes the board and verifies if one of the players won the game.

First, the predicate calls ``checkNumberPieces(Counter,Row,Column,Piece,Board)`` that verifies if one of the players won by having 8 pieces on the board. 

If a winner hasn't been declared after the previous verification, the predicate ``checkAll(Board,Player)`` is called. This predicate checks if a player won by having a 3 in-a-row (in any direction) on the board.

If any of the previous predicates succeed ``game_over(Board,Winner)`` succeeds and the winner is announced.

### Board State Evaluation - [utils.pl](./src/utils.pl)

The ``value(GameState,Player,Value)`` predicate handles all the board evaluation in the game. The way it evaluates a board is by assigning a score (for each player) to it: +100 points if the board has a 3 in-a-row, +1 point for each player's piece on the board and +1 point for each 2 in-a-row on the board. The following predicates were used to verify if the board contains any of these circunstances present: 

- The predicate ``checkAll(GameState,Player)``, that verifies if there is a 3 in-a-row on the board for the player;
- The predicate ``pointsForPiecesOnBoard(Board,Row,Column,Player,Points,FinalPoints)``, that verifies how many player's pieces there are on the board and returns the respective points;
- The predicate ``pointsForTwoInRow(Board,Player,Points)``, that verifies how many 2 in-a-rows there are on the board for the player and returns the respective points.

After verifying all the previous situations the predicate sums all the points and assigns them to the given player for that board.

The need to evaluate the current board state appears in the "Hard" difficulty of the computer. It is described in the next topic.

### Computer Move - [ai.pl](./src/ai.pl)

All the moves made by the computer are handled by the ``choose_move(GameState,Player,Difficulty,Element)`` predicate. This predicate behaves differently depending on which Bot/Difficulty is passed to it (either b1 or b2):

- If ``Difficulty`` is **b1**, the predicate uses  ``valid_moves(GameState,Player,UpdatedBoard)`` to get all the possible valid moves and then chooses one randomly using the predicate``choose(ListUpdatedBoard,Element)``.
- If ``Difficulty`` is **b2**, the predicate uses  ``valid_moves(GameState,Player,UpdatedBoard)`` once again to get all the possible valid moves, however, in this difficulty, all the boards resulting from these moves are evaluated and assigned a score using ``pointsOfBoards(ListBoards,ListBoardsAux,Player,FinalListOfBoards)``. After that, the boards with the best score are selected by the predicate ``selectBestBoards(BestPoints,FinalListOfBoards,FinalListOfBoardsAux,BestBoards)`` and one of them is chosen by the ``choose(BestBoards,Element)`` predicate.

## Conclusions

Initially there were some difficulties in the project's development, since we were still learning Prolog and the unique way it works compared to other languages. We eventually overcame these struggles once we started to get used to the syntax and features of the language. With that said, creating this project definitely improved our understanding and knowledge of Prolog.

Concerning known issues or problems, we didn't find any, all the required features were implemented and are working correctly.

Finally, as for possible improvements, we could've increased the complexity of the AI module, allowing us to add more difficulty modes (both harder and easier) to the game.



## Bibliography

- [SICStus Prolog Documentation](https://sicstus.sics.se/sicstus/docs/latest4/pdf/sicstus.pdf);
- [SWI Prolog Documentation](https://www.swi-prolog.org/pldoc/doc_for?object=manual);
- Moodle Lecture Materials.

