%Reads where the player wants to play the piece and checks if that position is occupied.
%If it isn't it calls the predicate putPiece to execute the play. If it is, Valid = 0 and playPiece is called again for a valid position.
%After the play is done it also updates the next player to play.
playPiece(Player,Board, NextPlayer, UpdatedBoard) :-
    readColumn(Column),
    readRow(Row),
    checkOccupied(Column, Row, Board, Player, NextPlayer, UpdatedBoard, Valid),
    (
        Valid =:= 0;
        (
            Valid =:= 1,
            putPiece(Board, Row, Column, Player, UpdatedBoard)
            %checkGameOver(Column, Row, UpdatedBoard, GameOver)
        )         
    ),
    (
        (
            Player =:= 1,
            NextPlayer is 2
        );
        (
            Player =:= 2,
            NextPlayer is 1
        )
    ).

%Predicates that convert the user input to the number of the column
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

%Predicates that convert the user input to the number of the row
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
%If it is, warn the user, do Valid = 0 and call playPiece again for another input
%If it isn't, Valid = 1
checkOccupied(Column, Row, Board, Player, NextPlayer, UpdatedBoard, Valid):-
    getSquarePiece(Column, Row, Content, Board),
    (
        (
            Content =:= 0,
            Valid is 1
        );
        (
            Content =:= 1,
            write('Square occupied by Black!\nSelect again:\n'),
            Valid is 0,
            playPiece(Player,Board, NextPlayer, UpdatedBoard)
        );
        (
            Content =:= 2,
            write('Square occupied by Red!\nSelect again:\n'),
            Valid is 0,
            playPiece(Player,Board, NextPlayer, UpdatedBoard)
        )
    ).  


%Checks if the game is over, not implemented yet
checkGameOver(Board):- fail.
