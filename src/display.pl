initialBoard([
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0],
    [0,0,0,0,0,0]
    ]).
    
    
print_board(X):-
    nl,
    write('   | A | B | C | D | E | F |\n'),
    write('---|---|---|---|---|---|---|\n'),
    print_matrix(X,0).

print_matrix([],6).

print_matrix([H|T],X):-
    X1 is X+1,
    write(X1),
    write('  |'),
    print_line(H),
    print_separation,
    nl,
    print_matrix(T,X1).

print_line([]).
print_line([H|T]):-
    print_element(H),
    print_line(T).


print_separation:-
    nl,
    write('---|---|---|---|---|---|---|').

print_element(X):-
    print_symbol(X,S),
    write(S),
    write(' |').

print_symbol(2,S):-S=' O'.
print_symbol(1,S):-S=' X'.
print_symbol(0,S):-S='  '.