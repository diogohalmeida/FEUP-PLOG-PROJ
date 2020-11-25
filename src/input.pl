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
    /*(
        (
            Player =:= 1,
            NextPlayer is 2
        );
        (
            Player =:= 2,
            NextPlayer is 1
        )
    ).*/



%Predicates that convert the user input to the number of the column
/*checkColumn('A', CheckedColumn) :-
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
    readColumn(CheckedColumn).*/

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
/*checkRow(1, CheckedRow) :-
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
    readRow(CheckedRow).*/

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



checkAll(Board,Piece):-
    checkAllRowsCols(7,7,Board,Piece).

threeInRowLeftDiagonal(0,_,_,_,_).

threeInRowLeftDiagonal(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
    NewCol is Col-1,
    NewCounter is Counter-1,
    threeInRowLeftDiagonal(NewCounter,NewRow,NewCol,Board,Piece),
    !.

threeInRowRightDiagonal(0,_,_,_,_).

threeInRowRightDiagonal(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
    NewCol is Col+1,
    NewCounter is Counter-1,
    threeInRowRightDiagonal(NewCounter,NewRow,NewCol,Board,Piece),
    !.

threeInRowColumn(0,_,_,_,_).

threeInRowColumn(Counter,Row,Col,Board,Piece):-
    Row < 7,
    Col < 7,
    getSquarePiece(Col,Row,Piece,Board),
    NewRow is Row-1,
    NewCounter is Counter-1,
    threeInRowColumn(NewCounter,NewRow,Col,Board,Piece),
    !.

threeInRowRow(0,_,_,_,_).

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
    getSquarePiece(Column,Row,Piece,Board),
    getSquarePiece(NewCol,NewRow,P,Board),
    (P==0->putPiece(Board,NewRow,NewCol,Piece,UpdatedBoard1),putPiece(UpdatedBoard1,Row,Column,0,UpdatedBoard);
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
    checkTopLeftDiagonal(NewN,NewRow,NewCol,Board,UpdatedBoard)).


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


checkNumberPieces(0,_,_,_,_).

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
    (
        checkNumberPieces(8,6,6,1,Board),
        assert(winner(1))
    );
    (
        checkNumberPieces(8,6,6,2,Board),
        assert(winner(2))
    );
    (
        checkAll(Board,1),
        assert(winner(1))
    );
    (
        checkAll(Board,2),
        assert(winner(2))
    ).


newPosition(InputRow,InputColumn,OutputRow,OutputColumn):- 
    OutputRow is InputRow, 
    OutputColumn is InputColumn.

newPosition(InputRow,InputColumn,OutputRow,OutputColumn):-
    InputColumn < 7,
    InputRow < 7,
    NewInputColumn is InputColumn + 1,
    newPosition(InputRow,NewInputColumn,OutputRow,OutputColumn).

newPosition(InputRow,InputColumn,OutputRow,OutputColumn):-
    InputColumn >= 7,
    InputRow < 7,
    NewInputColumn is 1,
    NewInputRow is InputRow + 1,
    newPosition(NewInputRow,NewInputColumn,OutputRow,OutputColumn).

valid(Player,Column, Row, Board,UpdatedBoard):-
    getSquarePiece(Column, Row, 0, Board),
    putPiece(Board, Row, Column, Player, UpdatedBoard1),
    repulsion(Row, Column, UpdatedBoard1,UpdatedBoard),
    !.

move(Player,Board,Row,Column,UpdatedBoard):-
    newPosition(1,1,Row,Column),
    valid(Player,Column, Row, Board, UpdatedBoard). 

%parseBoards([],Aux,Aux1,VictoryBoards,OtherBoards,_):- VictoryBoards = Aux, OtherBoards = Aux1.

/*parseBoards(AllBoards,VictoryBoards,NotLoosingBoards,PossibleWinningBoards,Player):-
    (
        Player=:=1->NextPlayer is 2;
        NextPlayer is 1   
    ),
    findWinningBoards(AllBoards,Player,[],VictoryBoards),
    findNotLosingBoards(AllBoards,NextPlayer,[],NotLoosingBoards),
    findPossibleWinningBoards(AllBoards,Player,[],PossibleWinningBoards),!.
*/

pointsForPiecesOnBoard(_,0,6,_,FinalPoints,FinalPoints).


pointsForPiecesOnBoard(Board,Row,Column,Player,Points,FinalPoints):-
    Column =< 0,
    Row > 0,
    NewColumn is 6,
    NewRow is Row-1,
    pointsForPiecesOnBoard(Board,NewRow,NewColumn,Player,Points,FinalPoints).


pointsForPiecesOnBoard(Board,Row,Column,Player,Points,FinalPoints):-
    Row > 0,
    Column > 0,
    getSquarePiece(Column,Row,Piece,Board),
    (
         Piece=:=Player-> NewPoints is Points+1;
         NewPoints = Points
    ),
    NewColumn is Column-1,
    pointsForPiecesOnBoard(Board,Row,NewColumn,Player,NewPoints,FinalPoints).



pointsTwoInRow(_,0,6,_,_,FinalPoints,FinalPoints).


pointsTwoInRow(Counter,Row,0,Board,Player,Points,FinalPoints):-
    Row > 0,
    NewRow is Row-1,
    NewColumn is 6,
    pointsTwoInRow(Counter,NewRow,NewColumn,Board,Player,Points,FinalPoints).



pointsTwoInRow(Counter,Row,Column,Board,Player,Points,FinalPoints):-
    Row > 0,
    Column > 0,
    (
        Counter=:=2->NewCounter is 0,NewPoints is Points+1;
        NewCounter is Counter,NewPoints is Points    
    ),
    (
        getSquarePiece(Column,Row,Player,Board)->UpdatedCounter is NewCounter+1;
        UpdatedCounter is 0    
    ),
    NewColumn is Column-1,
    pointsTwoInRow(UpdatedCounter,Row,NewColumn,Board,Player,NewPoints,FinalPoints).



pointsTwoInRowColumn(_,0,6,_,_,FinalPoints,FinalPoints).


pointsTwoInRowColumn(Counter,0,Column,Board,Player,Points,FinalPoints):-
    Column > 0,
    NewColumn is Column-1,
    NewRow is 6,
    pointsTwoInRowColumn(Counter,NewRow,NewColumn,Board,Player,Points,FinalPoints).



pointsTwoInRowColumn(Counter,Row,Column,Board,Player,Points,FinalPoints):-
    Row > 0,
    Column > 0,
    (
        Counter=:=2->NewCounter is 0,NewPoints is Points+1;
        NewCounter is Counter,NewPoints is Points    
    ),
    (
        getSquarePiece(Column,Row,Player,Board)->UpdatedCounter is NewCounter+1;
        UpdatedCounter is 0    
    ),
    NewRow is Row-1,
    pointsTwoInRowColumn(UpdatedCounter,NewRow,Column,Board,Player,NewPoints,FinalPoints).


pointsTwoInRowLeftDiagonal(5,6,_,_,FinalPoints,FinalPoints).


pointsTwoInRowLeftDiagonal(Row,Column,Board,Player,Points,FinalPoints):-
    Column >= 6,
    Row < 6,
    NewRow is Row+1,
    NewColumn is 1,
    pointsTwoInRowLeftDiagonal(NewRow,NewColumn,Board,Player,Points,FinalPoints).

pointsTwoInRowLeftDiagonal(Row,Column,Board,Player,Points,FinalPoints):-
    Row < 6,
    Column < 6,
    NewRow is Row + 1,
    NewColumn is Column + 1,
    getSquarePiece(Column,Row,Piece1,Board),
    getSquarePiece(NewColumn,NewRow,Piece2,Board),
    (
        (Piece1 =:= Player, Piece2=:= Player)->NewPoints is Points+1,pointsTwoInRowLeftDiagonal(Row,NewColumn,Board,Player,NewPoints,FinalPoints);
        pointsTwoInRowLeftDiagonal(Row,NewColumn,Board,Player,Points,FinalPoints)
    ).



pointsTwoInRowRightDiagonal(2,6,_,_,FinalPoints,FinalPoints).


pointsTwoInRowRightDiagonal(Row,Column,Board,Player,Points,FinalPoints):-
    Column >= 6,
    Row > 1,
    NewRow is Row-1,
    NewColumn is 1,
    pointsTwoInRowRightDiagonal(NewRow,NewColumn,Board,Player,Points,FinalPoints).

pointsTwoInRowRightDiagonal(Row,Column,Board,Player,Points,FinalPoints):-
    Row > 1,
    Column < 6,
    NewRow is Row - 1,
    NewColumn is Column + 1,
    getSquarePiece(Column,Row,Piece1,Board),
    getSquarePiece(NewColumn,NewRow,Piece2,Board),
    (
        (Piece1 =:= Player, Piece2=:= Player)->NewPoints is Points+1,pointsTwoInRowRightDiagonal(Row,NewColumn,Board,Player,NewPoints,FinalPoints);
    pointsTwoInRowRightDiagonal(Row,NewColumn,Board,Player,Points,FinalPoints)
    ).



pointsForTwoInRow(Board,Player,Points):-
    pointsTwoInRow(0,6,6,Board,Player,0,Points1),
    pointsTwoInRowColumn(0,6,6,Board,Player,0,Points2),
    pointsTwoInRowLeftDiagonal(1,1,Board,Player,0,Points3),
    pointsTwoInRowRightDiagonal(6,1,Board,Player,0,Points4),
    Points is (Points1 + Points2 + Points3 + Points4).
    



pointsOfBoards([],FinalListOfBoards,_,FinalListOfBoards).

pointsOfBoards([H|T],ListBoards,Player,FinalListOfBoards):-
    player(Player,OtherPlayer),
    /*(
        Player=:=1->OtherPlayer is 2;
        OtherPlayer is 1
    ),*/
    nth0(0,H,Row),
    nth0(1,H,Column),
    nth0(2,H,Board),
    (
        checkAll(Board,Player)->Points1 is 100;
        Points1 is 0
    ),
    (
        checkAll(Board,OtherPlayer)->Points2 is 100;
        Points2 is 0    
    ),
    pointsForPiecesOnBoard(Board,6,6,OtherPlayer,0,Points3),
    pointsForPiecesOnBoard(Board,6,6,Player,0,Points4),
    pointsForTwoInRow(Board,OtherPlayer,Points5),
    pointsForTwoInRow(Board,Player,Points6),
    Points is Points1-Points2-(2*Points3)+Points4-(20*Points5)+(5*Points6),
    append(ListBoards,[[Row,Column,Board,Points]],NewListBoards),
    pointsOfBoards(T,NewListBoards,Player,FinalListOfBoards).
    
selectBestBoards(_,[],FinalBestBoards,FinalBestBoards).

selectBestBoards(BestPoints,[H|T],BestBoards,FinalBestBoards):-
    nth0(3,H,Points),
    (
        BestPoints < Points->selectBestBoards(Points,T,[H],FinalBestBoards);
        (
            BestPoints=:=Points->append(BestBoards,[H],NewBestBoards),selectBestBoards(BestPoints,T,NewBestBoards,FinalBestBoards);
            selectBestBoards(BestPoints,T,BestBoards,FinalBestBoards)
            
        )
    ).


chooseBestMove(Player,Board,BoardChoosen):-
    findall([Row,Column,UpdatedBoard],move(Player,Board,Row,Column,UpdatedBoard),ListBoards),
    pointsOfBoards(ListBoards,[],Player,FinalListOfBoards),
    selectBestBoards(-200,FinalListOfBoards,[],BestBoards),
    choose(BestBoards,Element),
    nth0(0,Element,RowChoosen),
    nth0(1,Element,ColumnChoosen),
    nth0(2,Element,BoardChoosen),
    write('Pc Played in Row: '),
    write(RowChoosen),nl,
    write('Pc Played in Column: '),
    write(ColumnChoosen).



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

runPlayerVComputerOption(1).

runPlayerVComputerOption(2).

runComputerVComputerOption(1):-
    gameLoopPc.

runComputerVComputerOption(2):-
    gameLoopPc2.

