:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(random)).

%predicates given in the moodle section to have time of execution
reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.

%predicates for the implementation of call_nth in sicstus
:- use_module(library(structs),
         [new/2,
          dispose/1,
          get_contents/3,
          put_contents/3]).

:- meta_predicate(call_nth(0, ?)).
:- meta_predicate(call_nth1(0, +, ?)).

call_nth(Goal_0, Nth) :-
   new(unsigned_32, Counter),
   call_cleanup(call_nth1(Goal_0, Counter, Nth),
           dispose(Counter)).

call_nth1(Goal_0, Counter, Nth) :-
    nonvar(Nth),
    !,
    Nth \== 0,
    \+arg(Nth,s(1),2), % produces all expected errors
    call(Goal_0),
    get_contents(Counter, contents, Count0),
    Count1 is Count0+1,
    (  Nth == Count1
    -> !
    ;  put_contents(Counter, contents, Count1),
        fail
    ).

call_nth1(Goal_0, Counter, Nth) :-
    call(Goal_0),
    get_contents(Counter, contents, Count0),
    Count1 is Count0+1,
    put_contents(Counter, contents, Count1),
    Nth = Count1.

%predicate to convert a list of list to a flatten list
flatten([], []) :- !. 
flatten([L|Ls], FlatL) :-
    !,
    flatten(L, NewL),
    flatten(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten(L, [L]).

%predicate to apply the restrictions for the sum of a line be equal to Sum
sumLine([],_).
sumLine([H|T],Sum):-
    sum(H,#=,Sum),
    sumLine(T,Sum).

%predicate to apply the restriction of a number including a digit given by the user
includesDigit(Var, Number):-
    Var mod 10  #= Number.
includesDigit(Var, Number):-
    Var #> 0,
    Rest #= Var // 10,
    includesDigit(Rest, Number).

%predicate to iterate the list of vars to apply the restrictions in the includesDigit predicate
numberRestrictions([], _, _).
numberRestrictions([Var|T], InputList, Index):-
    nth1(Index, InputList, Num),
    includesDigit(Var, Num),
    NewIndex is Index + 1, numberRestrictions(T, InputList, NewIndex).

%predicates to convert a list to a list of lists
makeRow([],_,_,_,[]).

makeRow([H|T],RowLength,RowLength,CurrentRow,[NewCurrentRow|Rest]):-
    append(CurrentRow,[H],NewCurrentRow),
    makeRow(T,1,RowLength,[],Rest).

makeRow([H|T],CurrentRowLength,RowLength,CurrentRow,FinalRow):-
    append(CurrentRow,[H],NewCurrentRow),
    NewCurrentRowLength is CurrentRowLength + 1,
    makeRow(T,NewCurrentRowLength,RowLength,NewCurrentRow,FinalRow).


%predicate to solve the problem given in InputList with a sum of lines and rows equal to Sum and give the solution in OutputList
solver(InputList, Sum, OutputList):-
    flatten(InputList,FlattenList),
    nth1(1,InputList,Row),
    length(Row,RowLength),
    length(FlattenList,Length),
    length(OutputList,Length),
    domain(OutputList,1,Sum),
    makeRow(OutputList,1,RowLength,[],Rows), 
    transpose(Rows,Cols),
    sumLine(Rows,Sum),
    sumLine(Cols,Sum),
    numberRestrictions(OutputList,FlattenList,1),
    labeling([],OutputList).

%predicates to print the boards for the user
print_board(Board, Message):-
    nth1(1,Board,Row),
    length(Row,RowLength),
    nl,
    write(Message),
    nl,
    write('|'),
    print_separation(0,RowLength),
    nl,
    print_matrix(Board,0,RowLength).

print_matrix([],_,_).

print_matrix([H|T],X, RowLength):-
    X1 is X+1,
    write('|'),
    print_line(H),
    nl,
    write('|'),
    print_separation(0,RowLength),
    nl,
    print_matrix(T,X1,RowLength).

%Predicates that print every row of the board
print_line([]).
print_line([H|T]):-
    print_element(H),
    print_line(T).

%Prints the separator between rows 
print_separation(RowLength,RowLength).
print_separation(Counter,RowLength):-
    %nl.
    write('----|'),
    NewCounter is Counter+1,
    print_separation(NewCounter,RowLength).

%Prints an element
print_element(X):-
    X < 10,
    write('  '),
    write(X),
    write(' |').

print_element(X):-
    X >= 10,
    write(' '),
    write(X),
    write(' |').

%predicates to generate random labeling values 
randomLabelingValues(Var, _Rest, BB, BB1) :-
    fd_set(Var, Set),
    select_best_value(Set, Value),
    (   
        first_bound(BB, BB1), Var #= Value
        ;   
        later_bound(BB, BB1), Var #\= Value
    ).

select_best_value(Set, BestValue):-
    fdset_to_list(Set, Lista),
    length(Lista, Len),
    random(0, Len, RandomIndex),
    nth0(RandomIndex, Lista, BestValue).

%predicates to choose a random element of a list
choose([], []).
choose(List, Elt) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elt).

%predicate to choose a random digit to be shown
chooseRandomDigit(Number, Digit):-
    number_codes(Number,List),
    choose(List,Element),
    Digit is Element-48.

%predicate to verify if a predicate succeds more than once time
more_than_once(Goal) :-
    \+ \+ call_nth(Goal,2).

%predicate to generate a random problem
generateRandomPuzzle(RowLength,Sum,OutputList):-
    BoardSize is RowLength*RowLength,
    length(Aux,BoardSize),
    domain(Aux,1,Sum),
    makeRow(Aux,1,RowLength,[],Rows),
    transpose(Rows,Cols),
    sumLine(Rows,Sum),
    sumLine(Cols,Sum),
    labeling([value(randomLabelingValues)], Aux),
    maplist(chooseRandomDigit,Aux,OutputList).

%predicate to generate a random problem with unique solution
generateRandomPuzzleWithUniqueSolution(RowLength,Sum,OutputList):-
    BoardSize is RowLength*RowLength,
    length(Aux,BoardSize),
    domain(Aux,1,Sum),
    makeRow(Aux,1,RowLength,[],Rows),
    transpose(Rows,Cols),
    sumLine(Rows,Sum),
    sumLine(Cols,Sum),
    labeling([value(randomLabelingValues)], Aux),
    maplist(chooseRandomDigit,Aux,OutputList),
    once(makeRow(OutputList,1,RowLength,[],Matrix)),
    \+more_than_once(solver(Matrix,Sum,_)).

%predicate to geenrate a random puzzle with unique solution and display it to the user
cNoteGenerateUnique(RowLength,Sum, Matrix):-
    generateRandomPuzzleWithUniqueSolution(RowLength,Sum,OutputList),
    makeRow(OutputList,1,RowLength,[],Matrix),
    print_board(Matrix,'Problem generated:'). 

%predicate to geenrate a random puzzle and display it to the user
cNoteGenerate(RowLength,Sum, Matrix):-
    generateRandomPuzzle(RowLength,Sum,OutputList),
    makeRow(OutputList,1,RowLength,[],Matrix),
    print_board(Matrix,'Problem generated:').

%predicate to solver a given problem and display it to the user
cNote(InputList,Sum):-
    nth1(1,InputList,Row),
    length(Row,RowLength),
    once(print_board(InputList,'Grid:')),
    reset_timer,
    solver(InputList,Sum,OutputList),
    makeRow(OutputList,1,RowLength,[],Matrix),
    print_board(Matrix,'Solution:'),
    print_time, nl,
    fd_statistics.


/*============================= Menus =============================*/
%predicates to show the menus to the user with several options to choose

cNoteMenu:-
    printMainMenu,
    readMenuOption.

printMainMenu:-
    write('\n\n _______________________________________________________________________ \n'),
    write('|                                                                       |\n'),
    write('|                                                                       |\n'),
    write('|        ______        .__   __.   ______   .___________. _______       |\n'),
    write('|       /      |       |  \\ |  |  /  __  \\  |           ||   ____|      |\n'),
    write('|      |  ,----  ______|   \\|  | |  |  |  | `---|  |----`|  |__         |\n'),
    write('|      |  |     |______|  . `  | |  |  |  |     |  |     |   __|        |\n'),
    write('|      |  `----.       |  |\\   | |  `--   |     |  |     |  |____       |\n'),
    write('|       \\______|       |__| \\__|  \\______/      |__|     |_______|      |\n'),
    write('|                                                                       |\n'),   
    write('|         Add some digits before or after the digits in the grid        |\n'),
    write('|                so that each row and column sums to 100                |\n'),   
    write('|                                                                       |\n'),                                                                   
    write('|                    _______________________________                    |\n'),
    write('|                   |                               |                   |\n'),
    write('|                   | 1. Solve a Problem            |                   |\n'),
    write('|                   |                               |                   |\n'),
    write('|                   | 2. Generate a Problem         |                   |\n'),
    write('|                   |                               |                   |\n'),
    write('|                   | 0. Exit                       |                   |\n'),
    write('|                   |_______________________________|                   |\n'),
    write('|                                                                       |\n'),
    write('|_______________________________________________________________________|\n').


readMenuOption:-
    repeat,
        write('Select the desired option:\n'),
        once(read(Option)),
        checkMenuOption(Option),
    runOption(Option).


checkMenuOption(0).
checkMenuOption(1).
checkMenuOption(2).

checkMenuOption(_):-
    write('Invalid Option!\nTry Again:\n'),
    fail.

runOption(0):-
    write('\nExiting C-Note...\n').

runOption(1):-
    repeat,
        write('Write the desired grid to solve:\n'),
        once(read(Matrix)),
        cNote(Matrix, 100),
    cNoteMenu.
    

runOption(2):-
    printProblemMenu,
    readProblemMenuOption.


printProblemMenu:-
    write('\n\n _______________________________________________________________________ \n'),
    write('|                                                                       |\n'),
    write('|                                                                       |\n'),
    write('|        ______        .__   __.   ______   .___________. _______       |\n'),
    write('|       /      |       |  \\ |  |  /  __  \\  |           ||   ____|      |\n'),
    write('|      |  ,----  ______|   \\|  | |  |  |  | `---|  |----`|  |__         |\n'),
    write('|      |  |     |______|  . `  | |  |  |  |     |  |     |   __|        |\n'),
    write('|      |  `----.       |  |\\   | |  `--   |     |  |     |  |____       |\n'),
    write('|       \\______|       |__| \\__|  \\______/      |__|     |_______|      |\n'),
    write('|                                                                       |\n'),   
    write('|         Add some digits before or after the digits in the grid        |\n'),
    write('|                so that each row and column sums to 100                |\n'),   
    write('|                                                                       |\n'),                                                                   
    write('|                  __________________________________                   |\n'),
    write('|                 |                                  |                  |\n'),
    write('|                 | 1. Problem w/ unique solution    |                  |\n'),
    write('|                 |                                  |                  |\n'),
    write('|                 | 2. Problem w/ multiple solutions |                  |\n'),
    write('|                 |                                  |                  |\n'),
    write('|                 | 0. Go Back                       |                  |\n'),
    write('|                 |__________________________________|                  |\n'),
    write('|                                                                       |\n'),
    write('|_______________________________________________________________________|\n').


readGridSize(Size):-
    repeat,
        write('Write the desired Grid Size:\n'),
        once(read(Size)),
        checkSize(Size).

checkSize(Size):-
    Size > 0.

readProblemMenuOption:-
    repeat,
        write('Select the desired option:\n'),
        once(read(Option)),
        checkMenuOption(Option),
    runProblemOption(Option).


runProblemOption(0):-
    cNoteMenu.

runProblemOption(1):-
    readGridSize(Size),
    cNoteGenerateUnique(Size,100, Matrix),
    repeat,
        write('Do you want to see the solution to this problem? (0 - No | 1 - Yes):\n'),
        once(read(Option)),
        checkYesNo(Option),
    runSolutionOption(Option, Matrix).

runProblemOption(2):-
    readGridSize(Size),
    cNoteGenerate(Size , 100, Matrix),
    repeat,
        write('Do you want to see the solution to this problem? (0 - No | 1 - Yes):\n'),
        once(read(Option)),
        checkYesNo(Option),
    runSolutionOption(Option, Matrix).


checkYesNo(0).
checkYesNo(1).

checkYesNo(_):-
    write('Invalid Option!\nTry Again:\n'),
    fail.


runSolutionOption(0, _Matrix):-
    cNoteMenu.

runSolutionOption(1, Matrix):-
    cNote(Matrix, 100),
    cNoteMenu.


