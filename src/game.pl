:-dynamic(state/2).

player(1,2).
player(2,1).

startMenu:-
    printMainMenu,
    readMenuOption.

%Starts the game
start :-
    gameLoop(p,p).

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
/*gameLoop(p,p) :-
    initial(InitialBoard),
    assert(state(1,InitialBoard)),
    repeat,
        retract(state(Player,Board)),
        once(display_game(Board,Player)),
        once(playPiece(Player,Board,NextPlayer,UpdatedBoard)),
        assert(state(NextPlayer,UpdatedBoard)),
        checkGameOver(UpdatedBoard),                                    % checkGameOver is not implemented yet, it currently returns fail so the loop can be infinitely running 
    print_board(UpdatedBoard),
    retract(state(_,_)),
    endGame.*/

choose([], []).
choose(List, Elt) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elt),!.


gameLoop(Mode1,Mode2):-
    initial(InitialBoard),
    assert(state(1,InitialBoard)),
    assert(mode(Mode1,Mode2)),
    repeat,
        retract(state(Player,Board)),
        retract(mode(FirstMode,SecondMode)),
        once(display_game(Board,Player)),
        once(choosePlay(FirstMode,Player,Board,NextPlayer,UpdatedBoard)),
        assert(state(NextPlayer,UpdatedBoard)),
        assert(mode(SecondMode,FirstMode)),
        checkGameOver(UpdatedBoard),
    print_board(UpdatedBoard),
    retract(state(_,_)),
    retract(mode(_,_)),
    endGame.


playerMove(p,Player,Board,NextPlayer,UpdatedBoard):-
    once(playPiece(Player,Board,NextPlayer,UpdatedBoard)).

playerMove(b1,Player,Board,NextPlayer,UpdatedBoard):-
    findall([Row,Column,UpdatedBoard],move(Player,Board,Row,Column,UpdatedBoard),ListUpdatedBoard),
    choose(ListUpdatedBoard,Element),
    player(Player,NextPlayer),
    nth0(0,Element,RowChoosen),
    nth0(1,Element,ColumnChoosen),
    nth0(2,Element,UpdatedBoard),
    write('Pc Played in Row: '),
    write(RowChoosen),nl,
    write('Pc Played in Column: '),
    write(ColumnChoosen).

playerMove(b2,Player,Board,NextPlayer,UpdatedBoard):-
    chooseBestMove(Player,Board,UpdatedBoard),
    player(Player,NextPlayer).


choosePlay(FirstMode,Player,Board,NextPlayer,UpdatedBoard):-
    playerMove(FirstMode,Player,Board,NextPlayer,UpdatedBoard).


/*gameLoop(b1,b1):-
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
        assert(state(NextPlayer,BoardChoosen)),
        checkGameOver(BoardChoosen),
    print_board(BoardChoosen),
    retract(state(_,_)),
    endGame.


gameLoop(b2,b2):-
    initial(InitialBoard),
    assert(state(1,InitialBoard)),
    repeat,
        retract(state(Player,Board)),
        once(display_game(Board,Player)),
        chooseBestMove(Player,Board,BoardChoosen),
        player(Player,NextPlayer),
        assert(state(NextPlayer,BoardChoosen)),
        checkGameOver(BoardChoosen),
    print_board(BoardChoosen),
    retract(state(_,_)),
    endGame.*/
    

%Displays the result after ending the game
endGame:-
    retract(winner(Player)),
    write('3 in a row!\n'),
    (Player=:= 1->write('Black');
    write('Red')
    ),
    write(' Wins the Game!\n'),
    startMenu.
