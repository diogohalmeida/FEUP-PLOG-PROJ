:-dynamic(state/2).

%predicate that starts the game
start :-
    initial(GameState),
    gameLoop('Pedro','Diogo').

%predicate that sets up the initial board
initial(GameState) :-
    initialBoard(GameState).

%predicate that displays the initial board
display_game(GameState,Player):-
    print_board(GameState),
    (
        Player =:= 1,
        nl,
        write('Black Player Turn'),
        nl    
    );
    (
        Player =:= 2,
        nl,
        write('Red Player Turn'),
        nl    
    ).

%predicates that help implementing the game loop 
repeat.
repeat:-repeat.

%predicate that implements the game loop, correctly assigning the turn for each player and updating the board
gameLoop(Player1,Player2) :-
    initial(InitialBoard),
    assert(move(1,Player1)),
    assert(move(2,Player2)),
    assert(state(1,InitialBoard)),
    repeat,
        retract(state(Player,Board)),
        once(display_game(Board,Player)),
        once(playPiece(Player,Board,NextPlayer,UpdatedBoard)),
        assert(state(NextPlayer,UpdatedBoard)),
        checkGameOver(NextPlayer),                                    % is not implemented yet
    endGame.

%predicate that displays the result after ending the game
endGame:-
    state(Player,Board),
    write('3 in a row!\n'),
    write(Player),
    write('Wins the Game!').
