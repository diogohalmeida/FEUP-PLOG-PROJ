# Gekitai

## Intermediate Report  - PLOG

### T4_Gekitai3

| Name                            | Number    | E-Mail               |
| ------------------------------- | --------- | -------------------- |
| Diogo Henrique Pinto de Almeida | 201806630 | up201806630@fe.up.pt |
| Pedro Manuel Santos Queirós     | 201806329 | up201806329@fe.up.pt |



## The Game: Gekitai

### Game Description

Gekitai is a 2-player, 3-in-a-row game played on a 6x6 grid. Each player has eight colored markers and takes turns placing them anywhere on any open space on the board. 

![board](.\img\board.png)

### Rules

When placed, a marker pushes all adjacent pieces outwards one space if there is an open space for it to move to (or off the board).

If there is not an open space on the opposite side of the pushed piece, it does not push (a newly played piece cannot push two or more other lined-up pieces).

![board](.\img\repel.png)



 If a piece is shoved off of the board it is returned to the player.

![board](.\img\push.png)



The first player to either line up three of their color in a row at the end of their turn (after pushing) OR have all eight of their markers on the board (also after pushing), is declared the winner.

![board](.\img\3row.png)

[Source](https://boardgamegeek.com/boardgame/295449/gekitail) | [Rules](https://s3.amazonaws.com/geekdo-files.com/bgg260437?response-content-disposition=inline%3B%20filename%3D%22Gekitai_Rules.pdf%22&response-content-type=application%2Fpdf&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJYFNCT7FKCE4O6TA%2F20201101%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201101T160735Z&X-Amz-SignedHeaders=host&X-Amz-Expires=120&X-Amz-Signature=7e76faaaf75b807f90a3a36f4bf395bb78425eee24dce48029893d8f5643cd33)



## Internal Representation of the Game State

### Board

For the board representation we used lists within a list (a matrix). This proved to be the most efficient way to represent both rows and columns. For the pieces and their illustration, we used 3 integers: a 0 represents an empty space, with the Black and Red Players being represented by 1's and 2's, respectively. Below is the implementation of the board:

```
[
[0,0,0,0,1,0],
[0,1,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,2,0,0],
[0,2,0,0,0,0],
[0,0,0,0,0,0]
]
```

### Player / Player Turn

To acknowledge which player is supposed to play in a turn, we have an atom "state" that records the next player to move, this state is updated every game loop iteration, alternating between players 1 (Blacks) and 2 (Reds).

### Game Loop

In Gekitai, the Black Pieces Player starts first, positioning his piece in whatever cell he wants on the initially empty board. The Red Player then proceeds with his play. This Black-Red loop keeps going until the end of the game.

Therefore, the gameloop is processed the following way: 

1. Initially assert that the Black Player (1) goes first;
2. Enter the loop section, retrieving the current player for this turn;
3. Call the "play" predicate, passing it the player for the turn;
4. Receive from the "play" predicate the next player and updating the state atom;
5. At the end of loop, check if the game is over (3-in-a-row or 8 placed pieces):
   - **If it isn't**, go back to Step 2.
   - **If it is**, end the game and print the result.

### Game States

- #### Initial Situation

```
[
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0],
[0,0,0,0,0,0]
].
```

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

- #### Intermediate Situation

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

- #### Final Situation

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



## Game State Visualization

For the board pieces display, the values **0** (empty board), **1** (black player), **2** (red player) were replaced with symbols **' '**, **X** and **O**, respectively. These replacements were processed by the predicate ``print_symbol(Value, S)`` that checks the value (0, 1 or 2) and correctly assigns the correct symbol to S for it to be printed later on in ``print_element(X)``. 

The full board is displayed by the predicate ``print_board(X)``, that prints the header of the board and then calls ``print_matrix()``, that is in charge of printing each line and its separators recursively until it reaches its base case (``print_matrix([], 6)``).

During the game, each player is prompted to play in their turn by a message that asks for the column and row. Although the player chooses the column to play through a letter, this letter is actually converted to a number by the predicate (``checkColumn(Column, IndexCol)``), so the piece can placed in the correct position.

- #### Initial Situation 

<img src=".\img\initial.png" alt="initial" style="zoom: 150%;" />

- #### Intermediate Situation 

<img src=".\img\intermediate.png" alt="intermediate" style="zoom: 150%;" />

- #### Final Situation 

<img src=".\img\final.png" alt="final" style="zoom: 150%;" />



## Notes

To run the game:

- In SICStus, load src/gekitai.pl;
- Type play. in the terminal.

In player inputs, input letters for the columns (e.g. 'A') and numbers for the rows (e.g. '1').

