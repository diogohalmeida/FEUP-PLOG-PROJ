start :-
    initial(GameState),
    displayInitialBoard(GameState),
    gameLoop(GameState).

initial(GameState) :-
    initialBoard(GameState).

displayInitialBoard(GameState):-
    print_board(GameState).

gameLoop(GameState) :-
    blackPlayerTurn(GameState, BlackGameState),
    redPlayerTurn(BlackGameState, RedGameState),
    gameLoop(RedGameState).


blackPlayerTurn(GameState, NextGameState):-
    write('Black Turn (X)\n'),
    write('Row:\n'),
    read(R1),
    write('Column:\n'),
    read(C1),
    playPiece(GameState,R1,C1,1,NextGameState).


redPlayerTurn(GameState, NextGameState):-
    write('Red Turn (O)\n'),
    write('Row:\n'),
    read(R2),
    write('Column:\n'),
    read(C2),
    playPiece(GameState,R2,C2,2,NextGameState).
