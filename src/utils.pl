%nth0(?Index, ?List, ?Elem)
getSquarePiece(Column, Row, Content, GameState) :-
    CalcRow is Row-1,
    CalcColumn is Column-1,
    nth0(CalcRow, GameState, SelRow),
    nth0(CalcColumn, SelRow, Content),
    format('\nPiece: ~d ~d\nContent: ', [Column, Row]),
    write(Content),
    write('\n').

getNorthSquares(Column, Row, GameState, GameOver) :-
    CalcRow1 is Row-1,
    CalcColumn is Column-1,
    nth0(CalcRow1, GameState, SelRow1),
    nth0(CalcColumn, SelRow1, Content1),

    CalcRow2 is CalcRow1-1,
    write(CalcRow2),
    write('SKIP1\n'),
    (
        CalcRow2 =< 0;
        (
            write('NAO DEVIA ESTAR AQUI 1\n'),
            nth0(CalcRow2, GameState, SelRow2),
            nth0(CalcColumn, SelRow2, Content2)
        )
    ),

    CalcRow3 is CalcRow1-2,
    write(CalcRow3),
    write('SKIP2\n'),
    (
        CalcRow3 =< 0;
        (
            write('NAO DEVIA ESTAR AQUI 2\n'),
            nth0(CalcRow3, GameState, SelRow3),
            nth0(CalcColumn, SelRow3, Content3)
        )
    ),
    (
        (
            Content1 == 1,
            Content2 == 1,
            Content3 == 1,
            GameOver is 1
        );
        (
            Content1 == 2,
            Content2 == 2,
            Content3 == 2,
            GameOver is 2
        );
        (
            (Content1 == 0,
            GameOver is 0);
            
            (Content2 == 0,
            GameOver is 0);
            
            (Content3 == 0,
            GameOver is 0) 
        )
    ).



replace(_,_,[],[]).
replace(X,Y,[X|L1],[Y|L2]):-
	replace(X,Y,L1,L2).
replace(X,Y,[H|L1],[H|L2]):
	-X\=H,
	replace(X,Y,L1,L2).

