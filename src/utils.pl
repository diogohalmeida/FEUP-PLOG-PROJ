%predicate that gets an element from a specific cell
%nth0(?Index, ?List, ?Elem)
getSquarePiece(Column, Row, Content, GameState) :-
    CalcRow is Row-1,
    CalcColumn is Column-1,
    nth0(CalcRow, GameState, SelRow),
    nth0(CalcColumn, SelRow, Content).
