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
    playPiece(GameState,1,NextGameState).


redPlayerTurn(GameState, NextGameState):-
    write('Red Turn (O)\n'),
    playPiece(GameState,2,NextGameState).


endGame(Winner):-
    write('3 in a row!\n'),
    write(Winner),
    write('Wins the Game!').
