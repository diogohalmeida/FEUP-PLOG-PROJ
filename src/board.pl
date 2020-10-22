initialBoard([
[1,0,0,0,0,0],
[0,1,0,0,0,0],
[0,0,1,0,0,0],
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

print_symbol(1,S):-S=' X'.
print_symbol(0,S):-S='  '.


replace(_,_,[],[]).
replace(X,Y,[X|L1],[Y|L2]):-
	replace(X,Y,L1,L2).
replace(X,Y,[H|L1],[H|L2]):
	-X\=H,
	replace(X,Y,L1,L2).


playPiece(InitialMatrix,R,C,1,FinalMatrix):-
	initialBoard(InitialMatrix),
	print_board(InitialMatrix),
	playRow(R,InitialMatrix,C,1,FinalMatrix),
	print_board(FinalMatrix).
	
playRow(1,[Row|RestRow],C,1,[NewRow|RestRow]):-
	playColumn(C,Row,1,NewRow).
	
playRow(NRow,[Row|RestRow],C,1,[Row|NewRow]):-
	NRow > 1,
	N is NRow-1,
	playRow(N,RestRow,C,1,NewRow).
	
playColumn(1,[_|RestColumn],1,[1|RestColumn]).
playColumn(NColumn,[P|RestColumn],1,[P|NewColumn]):-
	NColumn > 1,
	N is NColumn-1,
	playColumn(N,RestColumn,1,NewColumn).