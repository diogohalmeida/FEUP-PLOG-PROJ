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



checkAll(Board,Piece):-
    checkAllRowsCols(7,7,Board,Piece).

threeInRowLeftDiagonal(0,_,_,_,Piece):-assert(winner(Piece)).

threeInRowLeftDiagonal(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
    NewCol is Col-1,
    NewCounter is Counter-1,
    threeInRowLeftDiagonal(NewCounter,NewRow,NewCol,Board,Piece),
    !.

threeInRowRightDiagonal(0,_,_,_,Piece):-assert(winner(Piece)).

threeInRowRightDiagonal(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
    NewCol is Col+1,
    NewCounter is Counter-1,
    threeInRowRightDiagonal(NewCounter,NewRow,NewCol,Board,Piece),
    !.

threeInRowColumn(0,_,_,_,Piece):-assert(winner(Piece)).

threeInRowColumn(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
    NewCounter is Counter-1,
    threeInRowColumn(NewCounter,NewRow,Col,Board,Piece),
    !.

threeInRowRow(0,_,_,_,Piece):-assert(winner(Piece)).

threeInRowRow(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewCol is Col-1,
    NewCounter is Counter-1,
    threeInRowRow(NewCounter,Row,NewCol,Board,Piece),
    !.

checkAllRowsCols(Row,Col,Board,Piece):-
    Row > 0,
    Col > 0,
    threeInRowLeftDiagonal(3,Row,Col,Board,Piece);
    threeInRowRightDiagonal(3,Row,Col,Board,Piece);
    threeInRowColumn(3,Row,Col,Board,Piece);
    threeInRowRow(3,Row,Col,Board,Piece).

checkAllRowsCols(Row,Col,Board,Piece):-
    Row > 0,
    Col > 0,
    NextRow is Row-1,
    checkAllRowsCols(NextRow,Col,Board,Piece).

checkAllRowsCols(Row,Col,Board,Piece):-
    Row > 0,
    Col > 0,
    NextCol is Col-1,
    checkAllRowsCols(Row,NextCol,Board,Piece).


checkTopLeftDiagonal(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row-1,
    NewCol is Column-1,
    NewRow > 0,
    NewCol > 0,
    getSquarePiece(Row,Column,Piece,Board),
    getSquarePiece(NewCol,NewRow,P,Board),
    (P==0->putPiece(Board,NewRow,NewCol,Piece,UpdatedBoard1), putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
    UpdatedBoard = Board).

checkTopLeftDiagonal(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row-1,
    NewRow =< 0,
    putPiece(Board,Row,Column,0,UpdatedBoard);
    NewCol is Column-1,
    NewCol =< 0,
    putPiece(Board,Row,Column,0,UpdatedBoard).

checkTopLeftDiagonal(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row-1,
    NewRow =< 0,
    UpdatedBoard = Board;
    NewCol is Column-1,
    NewCol =< 0,
    UpdatedBoard = Board.

checkTopLeftDiagonal(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row-1,
    NewCol is Column-1,
    NewRow > 0,
    NewCol > 0,
    NewN is N-1,
    getSquarePiece(NewCol,NewRow,Piece,Board),
    (Piece==0->UpdatedBoard = Board;
    checkTopLeftDiagonal(NewN,NewRow,NewCol,Piece,Board,UpdatedBoard)).


checkUpperColumn(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row-1,
    NewRow > 0,
    getSquarePiece(Column,Row,Piece,Board),
    getSquarePiece(Column,NewRow,P,Board),
    (P==0->putPiece(Board,NewRow,Column,Piece,UpdatedBoard1), putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
    UpdatedBoard = Board).

checkUpperColumn(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row-1,
    NewRow =< 0,
    putPiece(Board,Row,Column,0,UpdatedBoard).

checkUpperColumn(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row-1,
    NewRow > 0,
    NewN is N-1,
    getSquarePiece(Column,NewRow,Piece,Board),
    (Piece==0->UpdatedBoard = Board;
    checkUpperColumn(NewN,NewRow,Column,Board,UpdatedBoard)).

checkUpperColumn(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row-1,
    NewRow =< 0,
    Column > 0,
    UpdatedBoard = Board.


checkTopRightDiagonal(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row-1,
    NewRow > 0,
    NewCol is Column+1,
    NewCol < 7,
    getSquarePiece(Column,Row,Piece,Board),
    getSquarePiece(NewCol,NewRow,P,Board),
    (P==0->putPiece(Board,NewRow,NewCol,Piece,UpdatedBoard1), putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
    UpdatedBoard = Board).

checkTopRightDiagonal(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row-1,
    NewRow =< 0,
    putPiece(Board,Row,Column,0,UpdatedBoard);
    NewCol is Column+1,
    NewCol >= 7,
    putPiece(Board,Row,Column,0,UpdatedBoard).
    

checkTopRightDiagonal(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row-1,
    NewCol is Column+1,
    NewRow > 0,
    NewCol < 7,
    NewN is N-1,
    getSquarePiece(NewCol,NewRow,Piece,Board),
    (Piece==0->UpdatedBoard = Board;
    checkTopRightDiagonal(NewN,NewRow,NewCol,Board,UpdatedBoard)).


checkTopRightDiagonal(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row-1,
    NewRow =< 0,
    UpdatedBoard = Board;
    NewCol is Column+1,
    NewCol >= 7,
    UpdatedBoard = Board.


checkRightRow(0,Row,Column,Board,UpdatedBoard):-
    NewCol is Column+1,
    NewCol < 7,
    getSquarePiece(Column,Row,Piece,Board),
    getSquarePiece(NewCol,Row,P,Board),
    (P==0->putPiece(Board,Row,NewCol,Piece,UpdatedBoard1), putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
    UpdatedBoard = Board).

checkRightRow(0,Row,Column,Board,UpdatedBoard):-
    NewCol is Column+1,
    NewCol >= 7,
    putPiece(Board,Row,Column,0,UpdatedBoard).

checkRightRow(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewCol is Column+1,
    NewCol < 7,
    NewN is N-1,
    getSquarePiece(NewCol,Row,Piece,Board),
    (Piece==0->UpdatedBoard = Board;
    checkRightRow(NewN,Row,NewCol,Board,UpdatedBoard)).

checkRightRow(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewCol is Column+1,
    NewCol >= 7,
    Row > 0,
    UpdatedBoard = Board.

checkBottomRightDiagonal(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row+1,
    NewRow < 7,
    NewCol is Column+1,
    NewCol < 7,
    getSquarePiece(Column,Row,Piece,Board),
    getSquarePiece(NewCol,NewRow,P,Board),
    (P==0->putPiece(Board,NewRow,NewCol,Piece,UpdatedBoard1), putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
    UpdatedBoard = Board).

checkBottomRightDiagonal(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row+1,
    NewRow >= 7,
    putPiece(Board,Row,Column,0,UpdatedBoard);
    NewCol is Column+1,
    NewCol >= 7,
    putPiece(Board,Row,Column,0,UpdatedBoard).

checkBottomRightDiagonal(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row+1,
    NewRow < 7,
    NewCol is Column+1,
    NewCol < 7,
    NewN is N-1,
    getSquarePiece(NewCol,NewRow,Piece,Board),
    (Piece==0->UpdatedBoard = Board;
    checkBottomRightDiagonal(NewN,NewRow,NewCol,Board,UpdatedBoard)).

checkBottomRightDiagonal(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row+1,
    NewRow >= 7,
    UpdatedBoard = Board;
    NewCol is Column+1,
    NewCol >= 7,
    UpdatedBoard = Board.

checkBottomColumn(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row+1,
    NewRow < 7,
    getSquarePiece(Column,Row,Piece,Board),
    getSquarePiece(Column,NewRow,P,Board),
    (P==0->putPiece(Board,NewRow,Column,Piece,UpdatedBoard1), putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
    UpdatedBoard = Board).

checkBottomColumn(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row+1,
    NewRow >= 7,
    putPiece(Board,Row,Column,0,UpdatedBoard).

checkBottomColumn(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row+1,
    NewRow < 7,
    NewN is N-1,
    getSquarePiece(Column,NewRow,Piece,Board),
    (Piece==0->UpdatedBoard = Board;
    checkBottomColumn(NewN,NewRow,Column,Board,UpdatedBoard)).

checkBottomColumn(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row+1,
    NewRow >= 7,
    Column > 0,
    UpdatedBoard = Board.

checkBottomLeftDiagonal(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row+1,
    NewRow < 7,
    NewCol is Column-1,
    NewCol > 0,
    getSquarePiece(Column,Row,Piece,Board),
    getSquarePiece(NewCol,NewRow,P,Board),
    (P==0->putPiece(Board,NewRow,NewCol,Piece,UpdatedBoard1), putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
    UpdatedBoard = Board).

checkBottomLeftDiagonal(0,Row,Column,Board,UpdatedBoard):-
    NewRow is Row+1,
    NewRow >= 7,
    putPiece(Board,Row,Column,0,UpdatedBoard);
    NewCol is Column-1,
    NewCol =< 0,
    putPiece(Board,Row,Column,0,UpdatedBoard).

checkBottomLeftDiagonal(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row+1,
    NewRow < 7,
    NewCol is Column-1,
    NewCol > 0,
    NewN is N-1,
    getSquarePiece(NewCol,NewRow,Piece,Board),
    (Piece==0->UpdatedBoard = Board;
    checkBottomLeftDiagonal(NewN,NewRow,NewCol,Board,UpdatedBoard)).

checkBottomLeftDiagonal(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewRow is Row+1,
    NewRow >= 7,
    UpdatedBoard = Board;
    NewCol is Column-1,
    NewCol =< 0,
    UpdatedBoard = Board.


checkLefttRow(0,Row,Column,Board,UpdatedBoard):-
    NewCol is Column-1,
    NewCol > 0,
    getSquarePiece(Column,Row,Piece,Board),
    getSquarePiece(NewCol,Row,P,Board),
    (P==0->putPiece(Board,Row,NewCol,Piece,UpdatedBoard1), putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
    UpdatedBoard = Board).

checkLefttRow(0,Row,Column,Board,UpdatedBoard):-
    NewCol is Column-1,
    NewCol =< 0,
    putPiece(Board,Row,Column,0,UpdatedBoard).

checkLefttRow(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewCol is Column-1,
    NewCol > 0,
    NewN is N-1,
    getSquarePiece(NewCol,Row,Piece,Board),
    (Piece==0->UpdatedBoard = Board;
    checkLefttRow(NewN,Row,NewCol,Board,UpdatedBoard)).

checkLefttRow(N,Row,Column,Board,UpdatedBoard):-
    N > 0,
    NewCol is Column-1,
    NewCol =< 0,
    Row > 0,
    UpdatedBoard = Board.


checkNumberPieces(0,_,_,Piece,_):-assert(winner(Piece)).

checkNumberPieces(Counter,Row,Column,Piece,Board):-
    Column > 0,
    Row > 0,
    getSquarePiece(Column,Row,P,Board),
    (P=:=Piece->NewCounter is Counter-1;
        NewCounter = Counter),
    NewColumn is Column-1,
    checkNumberPieces(NewCounter,Row,NewColumn,Piece,Board).

checkNumberPieces(Counter,Row,Column,Piece,Board):-
    Column =< 0,
    NewColumn is 6,
    NewRow is Row -1,
    checkNumberPieces(Counter,NewRow,NewColumn,Piece,Board).


repulsion(Row,Column,Board,UpdatedBoard):-
    checkTopLeftDiagonal(1,Row,Column,Board,UpdatedBoard1),
    checkUpperColumn(1,Row,Column,UpdatedBoard1,UpdatedBoard2),
    checkTopRightDiagonal(1,Row,Column,UpdatedBoard2,UpdatedBoard3),
    checkRightRow(1,Row,Column,UpdatedBoard3,UpdatedBoard4),
    checkBottomRightDiagonal(1,Row,Column,UpdatedBoard4,UpdatedBoard5),
    checkBottomColumn(1,Row,Column,UpdatedBoard5,UpdatedBoard6),
    checkBottomLeftDiagonal(1,Row,Column,UpdatedBoard6,UpdatedBoard7),
    checkLefttRow(1,Row,Column,UpdatedBoard7,UpdatedBoard).


%Checks if the game is over, not implemented yet
checkGameOver(Board):- 
    checkNumberPieces(8,6,6,1,Board);
    checkNumberPieces(8,6,6,2,Board);
    checkAll(Board,1);
    checkAll(Board,2).


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
