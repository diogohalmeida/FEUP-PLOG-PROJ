%predicate to put the piece in the right cell
putPiece(InitialMatrix,R,C,Player,FinalMatrix):-           
	putRow(R,InitialMatrix,C,Player,FinalMatrix).
	
%predicates to find the right row to put the piece
putRow(1,[Row|RestRow],C,Player,[NewRow|RestRow]):-      
	putColumn(C,Row,Player,NewRow).
	
putRow(NRow,[Row|RestRow],C,Player,[Row|NewRow]):-
	NRow > 1,
	N is NRow-1,
	putRow(N,RestRow,C,Player,NewRow).

%predicates to find the right column to put the piece
putColumn(1,[_|RestColumn],Player,[Player|RestColumn]).
putColumn(NColumn,[Piece|RestColumn],Player,[Piece|NewColumn]):-
	NColumn > 1,
	N is NColumn-1,
	putColumn(N,RestColumn,Player,NewColumn).


%boards for the intermediate delivery
intermediateBoard([
    [1,2,0,0,0,0],
    [0,0,1,0,0,2],
    [0,2,0,1,0,0],
    [0,0,0,0,0,0],
    [0,1,1,2,0,0],
    [0,0,0,0,0,2]
    ]).

finalBoard([
    [1,2,0,0,0,0],
    [0,0,1,0,0,2],
    [0,2,0,1,0,0],
    [0,0,0,0,1,0],
    [0,1,1,0,0,0],
    [0,0,2,0,0,2]
    ]).

%predicates that display the intermediate board and the final board examples for the intermediate delivery
intermediate:-
	intermediateBoard(IntermediateBoard),
	print_board(IntermediateBoard).

final:-
	finalBoard(FinalBoard),
	print_board(FinalBoard).
