:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(random)).

reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.

%implementation of call_nth in sicstus
%:- module(call_nth, [call_nth/2]).

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

flatten([], []) :- !. 
flatten([L|Ls], FlatL) :-
    !,
    flatten(L, NewL),
    flatten(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten(L, [L]).

/*cNote(InitialBoard, FinalBoard):-
    flatten(InitialBoard,BoardValues),
    nth1(1,BoardValues,Elem1);
    nth1(2,BoardValues,Elem2);
    nth1(3,BoardValues,Elem3);
    nth1(4,BoardValues,Elem4);
    nth1(5,BoardValues,Elem5);
    nth1(6,BoardValues,Elem6);
    nth1(7,BoardValues,Elem7);
    nth1(8,BoardValues,Elem8);
    nth1(9,BoardValues,Elem9);
    Vars = [A1,A2,A3,A4,A5,A6,A7,A8,A9],
    domain(Vars,0,9),
    A1 + A2 + A3 #= 100,
    A4 + A5 + A6 #= 100,
    A7 + A8 + A9 #= 100,
    A1 + A4 + A7 #= 100,
    A2 + A5 + A8 #= 100,
    A3 + A6 + A9 #= 100,*/

sumLine([],_).
sumLine([H|T],Sum):-
    sum(H,#=,Sum),
    sumLine(T,Sum).

includesDigit(Var, Number):-
    Var mod 10  #= Number.
includesDigit(Var, Number):-
    Var #> 0,
    Rest #= Var // 10,
    includesDigit(Rest, Number).

numberRestrictions([], _, _).
numberRestrictions([Var|T], InputList, Index):-
    nth1(Index, InputList, Num),
    includesDigit(Var, Num),
    NewIndex is Index + 1, numberRestrictions(T, InputList, NewIndex).

makeRow([],_,_,_,[]).

makeRow([H|T],RowLength,RowLength,CurrentRow,[NewCurrentRow|Rest]):-
    append(CurrentRow,[H],NewCurrentRow),
    makeRow(T,1,RowLength,[],Rest).

makeRow([H|T],CurrentRowLength,RowLength,CurrentRow,FinalRow):-
    append(CurrentRow,[H],NewCurrentRow),
    NewCurrentRowLength is CurrentRowLength + 1,
    makeRow(T,NewCurrentRowLength,RowLength,NewCurrentRow,FinalRow).



solver(InputList, Sum, OutputList):-
    flatten(InputList,FlattenList),
    nth1(1,InputList,Row),
    length(Row,RowLength),
    length(FlattenList,Length),
    length(OutputList,Length),
    domain(OutputList,1,Sum),
    %Rows = InputList,
    makeRow(OutputList,1,RowLength,[],Rows), 
    %write(Rows),
    transpose(Rows,Cols),
    sumLine(Rows,Sum),
    sumLine(Cols,Sum),
    numberRestrictions(OutputList,FlattenList,1),
    labeling([],OutputList).
    %makeRow(OutputList,1,RowLength,[],Teste).
    %write(Teste),!.

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

%predicates copied from stackoverflow to generate random labeling values 
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

choose([], []).
choose(List, Elt) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, Elt).

chooseRandomDigit(Number, Digit):-
    number_codes(Number,List),
    choose(List,Element),
    Digit is Element-48.

/*call_nth(Goal_0, C) :-
    State = count(0,_), % note the extra argument which remains a variable
    Goal_0,
    arg(1, State, C1),
    C2 is C1+1,
    nb_setarg(1, State, C2),
    C = C2.*/

more_than_once(Goal) :-
    \+ \+ call_nth(Goal,2).

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

cNoteGenerateUnique(RowLength,Sum,'unique'):-
    generateRandomPuzzleWithUniqueSolution(RowLength,Sum,OutputList),
    makeRow(OutputList,1,RowLength,[],Matrix),
    print_board(Matrix,'Problem generated:'). 

cNoteGenerate(RowLength,Sum):-
    generateRandomPuzzle(RowLength,Sum,OutputList),
    makeRow(OutputList,1,RowLength,[],Matrix),
    print_board(Matrix,'Problem generated:').

cNote(InputList,Sum):-
    nth1(1,InputList,Row),
    length(Row,RowLength),
    once(print_board(InputList,'Before:')),
    reset_timer,
    solver(InputList,Sum,OutputList),
    makeRow(OutputList,1,RowLength,[],Matrix),
    print_board(Matrix,'After:'),
    print_time, nl,
    fd_statistics.




