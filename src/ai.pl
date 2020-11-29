choose_move(GameState,Player,b2,Element):-
    valid_moves(GameState,Player,ListBoards),
    pointsOfBoards(ListBoards,[],Player,FinalListOfBoards),
    selectBestBoards(-200,FinalListOfBoards,[],BestBoards),
    choose(BestBoards,Element).

choose_move(GameState,Player,b1,Element):-
    valid_moves(GameState,Player,ListUpdatedBoard),
    choose(ListUpdatedBoard,Element).


chooseBestMove(Player,Board,BoardChoosen):-
    valid_moves(Board,Player,ListBoards),
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