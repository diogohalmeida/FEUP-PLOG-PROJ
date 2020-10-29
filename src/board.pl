putPiece(InitialMatrix,R,C,Player,FinalMatrix):-
	putRow(R,InitialMatrix,C,Player,FinalMatrix),
	print_board(FinalMatrix).
	
putRow(1,[Row|RestRow],C,Player,[NewRow|RestRow]):-
	putColumn(C,Row,Player,NewRow).
	
putRow(NRow,[Row|RestRow],C,Player,[Row|NewRow]):-
	NRow > 1,
	N is NRow-1,
	putRow(N,RestRow,C,Player,NewRow).
	
putColumn(1,[_|RestColumn],Player,[Player|RestColumn]).
putColumn(NColumn,[Piece|RestColumn],Player,[Piece|NewColumn]):-
	NColumn > 1,
	N is NColumn-1,
	putColumn(N,RestColumn,Player,NewColumn).


