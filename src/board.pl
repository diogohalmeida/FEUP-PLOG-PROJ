replace(_,_,[],[]).
replace(X,Y,[X|L1],[Y|L2]):-
	replace(X,Y,L1,L2).
replace(X,Y,[H|L1],[H|L2]):
	-X\=H,
	replace(X,Y,L1,L2).


playPiece(InitialMatrix,R,C,Player,FinalMatrix):-
	print_board(InitialMatrix),
	playRow(R,InitialMatrix,C,Player,FinalMatrix),
	print_board(FinalMatrix).
	
playRow(1,[Row|RestRow],C,Player,[NewRow|RestRow]):-
	playColumn(C,Row,Player,NewRow).
	
playRow(NRow,[Row|RestRow],C,Player,[Row|NewRow]):-
	NRow > 1,
	N is NRow-1,
	playRow(N,RestRow,C,Player,NewRow).
	
playColumn(1,[_|RestColumn],Player,[Player|RestColumn]).
playColumn(NColumn,[Piece|RestColumn],Player,[Piece|NewColumn]):-
	NColumn > 1,
	N is NColumn-1,
	playColumn(N,RestColumn,Player,NewColumn).


