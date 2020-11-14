:-dynamic(state/2).

%Starts the game
start :-
    initial(GameState),
    gameLoop('Pedro','Diogo').

%Sets up the initial board
initial(GameState) :-
    initialBoard(GameState).

%Displays the initial board and signals the next player's turn
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

%Predicates that help implementing the game loop 
repeat.
repeat:-repeat.

%Implements the game loop, correctly assigning the turn for each player, updating the board and checking game over. 
%The game loop ends when the this predicate detects game over (checkGameOver is true)
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
        checkGameOver(UpdatedBoard),                                    % checkGameOver is not implemented yet, it currently returns fail so the loop can be infinitely running
    print_board(UpdatedBoard),
    endGame.

%Displays the result after ending the game
endGame:-
    winner(Player),
    write('3 in a row!\n'),
    (Player=:= 1->write('Black');
    write('Red')
    ),
    write(' Wins the Game!').
