playPiece(GameState, Player, NextGameState) :-
    readColumn(Column),
    readRow(Row),
    checkOccupied(Column, Row, GameState, Player, NextGameState, Valid),
    (
        Valid == 0;
        (
            Valid == 1,
            putPiece(GameState, Row, Column, Player, NextGameState),
            checkGameOver(Column, Row, NextGameState, GameOver)
        )         
    ).


checkColumn('A', CheckedColumn) :-
    CheckedColumn=1.
checkColumn('B', CheckedColumn) :-
    CheckedColumn=2.
checkColumn('C', CheckedColumn) :-
    CheckedColumn=3.
checkColumn('D', CheckedColumn) :-
    CheckedColumn=4.
checkColumn('E', CheckedColumn) :-
    CheckedColumn=5.
checkColumn('F', CheckedColumn) :-
    CheckedColumn=6.
checkColumn(_Column, CheckedColumn) :-
    write('Invalid Column!\nSelect again:\n'),
    readColumn(CheckedColumn).

checkRow(1, CheckedRow) :-
    CheckedRow=1.
checkRow(2, CheckedRow) :-
    CheckedRow=2.
checkRow(3, CheckedRow) :-
    CheckedRow=3.
checkRow(4, CheckedRow) :-
    CheckedRow=4.
checkRow(5, CheckedRow) :-
    CheckedRow=5.
checkRow(6, CheckedRow) :-
    CheckedRow=6.
checkRow(_Row, CheckedRow) :-
    write('Invalid Row!\nSelect again:\n'),
    readRow(CheckedRow).

readRow(CheckedRow) :-
    write('Row:\n'),
    read(Row),
    checkRow(Row, CheckedRow).

readColumn(CheckedColumn) :-
    write('Column:\n'),
    read(Column),
    checkColumn(Column, CheckedColumn).

checkOccupied(Column, Row, GameState, Player, NextGameState, Valid):-
    getSquarePiece(Column, Row, Content, GameState),
    (
        (
            Content == 0,
            Valid is 1
        );
        (
            Content == 1,
            write('Square occupied by Black!\nSelect again:\n'),
            Valid is 0,
            playPiece(GameState, Player, NextGameState)
        );
        (
            Content == 2,
            write('Square occupied by Red!\nSelect again:\n'),
            Valid is 0,
            playPiece(GameState, Player, NextGameState)
        )
    ).  

checkGameOver(Column, Row, GameState, GameOver):-
    getNorthSquares(Column, Row, GameState, GameOver),
    write(GameOver).
    (
        (
        GameOver == 1,
        endGame("Black")
        );
        (
        GameOver == 2,
        endGame("Red")
        );
        GameOver == 0
    ).
