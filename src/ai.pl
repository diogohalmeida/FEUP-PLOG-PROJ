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