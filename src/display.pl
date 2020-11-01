%intial Board where every cell is emtpy
initialBoard([
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0]
    ]).

%predicate that shows to the user the board    
print_board(X):-
    nl,
    write('   | A | B | C | D | E | F |\n'),
    write('---|---|---|---|---|---|---|\n'),
    print_matrix(X,0).

%predicates that print the matrix (board)
print_matrix([],6).

print_matrix([H|T],X):-
    X1 is X+1,
    write(X1),
    write('  |'),
    print_line(H),
    print_separation,
    nl,
    print_matrix(T,X1).

%predicates that print every row of the board
print_line([]).
print_line([H|T]):-
    print_element(H),
    print_line(T).

%predicate that prints the separator between rows 
print_separation:-
    nl,
    write('---|---|---|---|---|---|---|').

%predicate that print an element
print_element(X):-
    print_symbol(X,S),
    write(S),
    write(' |').

%predicates that replace the internal representation for the correct symbols in display 
print_symbol(2,S):-
    S=' O'.
print_symbol(1,S):-
    S=' X'.
print_symbol(0,S):-
    S='  '.