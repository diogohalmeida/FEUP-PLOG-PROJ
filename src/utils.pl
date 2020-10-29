%nth0(?Index, ?List, ?Elem)
getSquarePiece(Column, Row, Content, GameState) :-
    CalcRow is Row-1,
    CalcColumn is Column-1,
    nth0(CalcRow, GameState, SelRow),
    nth0(CalcColumn, SelRow, Content),
    format('\nPiece: ~d ~d\nContent: ', [Column, Row]),
    write(Content),
    write('\n').





replace(_,_,[],[]).
replace(X,Y,[X|L1],[Y|L2]):-
	replace(X,Y,L1,L2).
replace(X,Y,[H|L1],[H|L2]):
	-X\=H,
	replace(X,Y,L1,L2).

