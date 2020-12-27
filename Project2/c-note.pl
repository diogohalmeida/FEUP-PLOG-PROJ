:-use_module(library(clpfd)).
:-use_module(library(lists)).

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

cNote(InputList):-
    nth1(1,InputList,Row),
    length(Row,RowLength),
    once(print_board(InputList,'Before:')),
    solver(InputList,100,OutputList),
    makeRow(OutputList,1,RowLength,[],Matrix),
    print_board(Matrix,'After:').




