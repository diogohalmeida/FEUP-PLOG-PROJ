:-dynamic(state/2).

start :-
    initial(GameState),
    displayInitialBoard(GameState),
    gameLoop('Pedro','Diogo').

initial(GameState) :-
    initialBoard(GameState).

displayInitialBoard(GameState):-
    print_board(GameState).

repeat.
repeat:-repeat.

gameLoop(Player1,Player2) :-
    initial(InitialBoard),
    assert(move(1,Player1)),
    assert(move(2,Player2)),
    assert(state(1,InitialBoard)),
    repeat,
        retract(state(Player,Board)),
        once(playPiece(Player,Board,NextPlayer,UpdatedBoard)),
        assert(state(NextPlayer,UpdatedBoard)),
        checkGameOver(NextPlayer),
    endGame.


    blackPlayerTurn(GameState, BlackGameState),
    redPlayerTurn(BlackGameState, RedGameState),
    gameLoop(RedGameState).


blackPlayerTurn(GameState, NextGameState):-
    write('Black Turn (X)\n'),
    playPiece(GameState,1,NextGameState).


redPlayerTurn(GameState, NextGameState):-
    write('Red Turn (O)\n'),
    playPiece(GameState,2,NextGameState).


endGame:-
    state(Player,Board),
    write('3 in a row!\n'),
    write(Player),
    write('Wins the Game!').
