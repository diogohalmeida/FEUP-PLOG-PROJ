%Initial Board where every cell is emtpy
initialBoard([
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0]
    ]).

%Shows the board to the user  
print_board(X):-
    nl,
    write('   | A | B | C | D | E | F |\n'),
    write('---|---|---|---|---|---|---|\n'),
    print_matrix(X,0).

%Predicates that print the matrix (board)
print_matrix([],6).

print_matrix([H|T],X):-
    X1 is X+1,
    write(X1),
    write('  |'),
    print_line(H),
    print_separation,
    nl,
    print_matrix(T,X1).

%Predicates that print every row of the board
print_line([]).
print_line([H|T]):-
    print_element(H),
    print_line(T).

%Prints the separator between rows 
print_separation:-
    nl,
    write('---|---|---|---|---|---|---|').

%Prints an element
print_element(X):-
    print_symbol(X,S),
    write(S),
    write(' |').

%Predicates that replace the internal representation of the pieces for the correct symbols in display 
print_symbol(2,S):-
    S=' O'.
print_symbol(1,S):-
    S=' X'.
print_symbol(0,S):-
    S='  '.