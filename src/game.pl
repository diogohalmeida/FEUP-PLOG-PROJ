:-dynamic(state/2).

player(1,2).
player(2,1).

startMenu:-
    printMainMenu,
    readMenuOption.

%Starts the game
start :-
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


%Implements the game loop, correctly assigning the turn for each player, updating the board and checking game over. 
%The game loop ends when the this predicate detects game over (checkGameOver is true)
gameLoop(Player1,Player2) :-
    initial(InitialBoard),
    %assert(move(1,Player1)),
    %assert(move(2,Player2)),
    assert(state(1,InitialBoard)),
    repeat,
        retract(state(Player,Board)),
        once(display_game(Board,Player)),
        once(playPiece(Player,Board,NextPlayer,UpdatedBoard)),
        assert(state(NextPlayer,UpdatedBoard)),
        checkGameOver(UpdatedBoard),                                    % checkGameOver is not implemented yet, it currently returns fail so the loop can be infinitely running 
    print_board(UpdatedBoard),
    retract(state(_,_)),
    endGame.

choose([], []).
choose(List, Elt) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elt),!.


gameLoopPc:-
    initial(InitialBoard),
    assert(state(1,InitialBoard)),
    repeat,
        retract(state(Player,Board)),
        once(display_game(Board,Player)),
        findall([Row,Column,UpdatedBoard],move(Player,Board,Row,Column,UpdatedBoard),ListUpdatedBoard),
        choose(ListUpdatedBoard,Element),
        player(Player,NextPlayer),
        nth0(0,Element,RowChoosen),
        nth0(1,Element,ColumnChoosen),
        nth0(2,Element,BoardChoosen),
        write('Pc Played in Row: '),
        write(RowChoosen),nl,
        write('Pc Played in Column: '),
        write(ColumnChoosen),
        /*(Player=:=1->NextPlayer is 2;
            NextPlayer is 1    
        ),*/
        assert(state(NextPlayer,BoardChoosen)),
        checkGameOver(BoardChoosen),
    print_board(BoardChoosen),
    retract(state(_,_)),
    endGame.


gameLoopPc2:-
    initial(InitialBoard),
    assert(state(1,InitialBoard)),
    repeat,
        retract(state(Player,Board)),
        once(display_game(Board,Player)),
        chooseBestMove(Player,Board,BoardChoosen),
        player(Player,NextPlayer),
        /*(Player=:=1->NextPlayer is 2;
            NextPlayer is 1    
        ),*/
        assert(state(NextPlayer,BoardChoosen)),
        checkGameOver(BoardChoosen),
    print_board(BoardChoosen),
    retract(state(_,_)),
    endGame.
    

%Displays the result after ending the game
endGame:-
    retract(winner(Player)),
    write('3 in a row!\n'),
    (Player=:= 1->write('Black');
    write('Red')
    ),
    write(' Wins the Game!\n'),
    startMenu.
