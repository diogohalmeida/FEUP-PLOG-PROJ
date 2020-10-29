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



/*print_matrix([],6).

print_matrix([H|T],X):-
    X1 is X+1,
    print_line(H),
    print_matrix(T,X1).

print_line([]).

print_line([H|T],Row,Column,Board):-
    (
        H =:= 1,
        getSquarePiece(Column, Row, 1, Board)
    );
    (
        H =:= 0,
        NextColumn is Column+1,
        print_line(T,Row,NextColumn,Board).
    )
    write(H),

checkDirections(Column, Row):-*/


checkGameOver(Board):- fail.
