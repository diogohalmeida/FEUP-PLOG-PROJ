%Reads where the player wants to play the piece and checks if that position is occupied.
%If it isn't it calls the predicate putPiece to execute the play. If it is, repeat the input
%After the play is done it also updates the next player to play.
playPiece(Player,Board, NextPlayer, UpdatedBoard) :-
    repeat,
        once(readColumn(Column)),
        once(readRow(Row)),
        checkOccupied(Column, Row, Board),
    putPiece(Board, Row, Column, Player, UpdatedBoard1),
    repulsion(Row, Column, UpdatedBoard1,UpdatedBoard),
    player(Player,NextPlayer).      




%Predicates that convert the user input to the number of the column
checkColumn('A', 1).
checkColumn('B', 2).
checkColumn('C', 3).
checkColumn('D', 4).
checkColumn('E', 5).
checkColumn('F', 6).
checkColumn(_Column, CheckedColumn) :-
    write('Invalid Column!\nSelect again:\n'),
    readColumn(CheckedColumn).

%Predicates that convert the user input to the number of the row
checkRow(1, 1).
checkRow(2, 2).
checkRow(3, 3).
checkRow(4, 4).
checkRow(5, 5).
checkRow(6, 6).
checkRow(_Row, CheckedRow) :-
    write('Invalid Row!\nSelect again:\n'),
    readRow(CheckedRow).

%Prompts user input for the row and reads it
readRow(CheckedRow) :-
    write('Row:\n'),
    read(Row),
    checkRow(Row, CheckedRow).


%Prompts user input for the column and reads it
readColumn(CheckedColumn) :-
    write('Column:\n'),
    read(Column),
    checkColumn(Column, CheckedColumn).

%Verifies if a cell is already occupied for another piece
%If it is repeat the input
checkOccupied(Column, Row, Board):-
    getSquarePiece(Column, Row, Content, Board),
    Content =:= 0.

checkOccupied(Column, Row, Board):-
    getSquarePiece(Column, Row, Content, Board),
    Content =:= 1,
    write('Square occupied by Black!\nSelect again:\n'),
    fail.

checkOccupied(Column, Row, Board):-
    getSquarePiece(Column, Row, Content, Board),
    Content =:= 2,
    write('Square occupied by Red!\nSelect again:\n'),
    fail.

readMenuOption:-
    repeat,
        write('Select the desired mode:\n'),
        once(read(Option)),
        checkMenuOption(Option),
    runOption(Option).

checkMenuOption(Option):-
    Option >= 0,
    Option =< 3.

checkMenuOption(_):-
    write('Invalid Option!\nTry Again:\n'),
    fail.

runOption(0):-
    write('\nExiting game...\n').

runOption(1):-
    start.

runOption(2):-
    repeat,
        printSecondaryMenu,
        once(read(Option)),
        checkSecondaryMenuOption(Option),
    runPlayerVComputerOption(Option).
    

runOption(3):-
    repeat,
        printSecondaryMenu,
        once(read(Option)),
        checkSecondaryMenuOption(Option),
    runComputerVComputerOption(Option).


checkSecondaryMenuOption(Option):-
    Option >= 0,
    Option =< 2.

checkSecondaryMenuOption(_):-
    write('Invalid Option!\nTry Again:\n'),
    fail.

runPlayerVComputerOption(1):-
    gameLoop(p,b1).

runPlayerVComputerOption(2):-
    gameLoop(p,b2).

runComputerVComputerOption(1):-
    gameLoop(b1,b1).

runComputerVComputerOption(2):-
    gameLoop(b2,b2).

