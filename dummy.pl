% A Sudoku solver.  The basic idea is for each position,
% check that it is a digit with `digit`.  Then verify that the digit
% chosen doesn't violate any constraints (row, column, and cube).
% If no constraints were violated, proceed further.  If a constraint
% was violated, then backtrack to the last digit choice and move from
% there (the Prolog engine should handle this for you automatically).
% If we reach the end of the board with this scheme, it means that
% the whole thing is solved.

% YOU SHOULD FILL IN THE SOLVE PROCEDURE, DOWN BELOW.

digit(1).
digit(2).
digit(3).
digit(4).
digit(5).
digit(6).
digit(7).
digit(8).
digit(9).

numBetween(Num, Lower, Upper) :-
        Num >= Lower,
        Num =< Upper.

% cubeBounds: (RowLow, RowHigh, ColLow, ColHigh, CubeNumber)
cubeBounds(0, 2, 0, 2, 0).
cubeBounds(0, 2, 3, 5, 1).
cubeBounds(0, 2, 6, 8, 2).
cubeBounds(3, 5, 0, 2, 3).
cubeBounds(3, 5, 3, 5, 4).
cubeBounds(3, 5, 6, 8, 5).
cubeBounds(6, 8, 0, 2, 6).
cubeBounds(6, 8, 3, 5, 7).
cubeBounds(6, 8, 6, 8, 8).

% Given a board and the index of a column of interest (0-indexed),
% returns the contents of the column as a list.
% columnAsList: (Board, ColumnNumber, AsRow)
columnAsList([], _, []).
columnAsList([Head|Tail], ColumnNum, [Item|Rest]) :-
        nth0(ColumnNum, Head, Item),
        columnAsList(Tail, ColumnNum, Rest).

% given which row and column we are in, gets which cube
% is relevant.  A helper ultimately for `getCube`.
% cubeNum: (RowNum, ColNum, WhichCube)
cubeNum(RowNum, ColNum, WhichCube) :-
        cubeBounds(RowLow, RowHigh, ColLow, ColHigh, WhichCube),
        numBetween(RowNum, RowLow, RowHigh),
        numBetween(ColNum, ColLow, ColHigh).

% Drops the first N elements from a list.  A helper ultimately
% for `getCube`.
% drop: (InputList, NumToDrop, ResultList)
drop([], _, []):-!.
drop(List, 0, List):-!.
drop([_|Tail], Num, Rest) :-
        Num > 0,
        NewNum is Num - 1,
        drop(Tail, NewNum, Rest).

% Takes the first N elements from a list.  A helper ultimately
% for `getCube`.
% take: (InputList, NumToTake, ResultList)
take([], _, []):-!.
take(_, 0, []):-!.
take([Head|Tail], Num, [Head|Rest]) :-
        Num > 0,
        NewNum is Num - 1,
        take(Tail, NewNum, Rest).

% Gets a sublist of a list in the same order, inclusive.
% A helper for `getCube`.
% sublist: (List, Start, End, NewList)
sublist(List, Start, End, NewList) :-
        drop(List, Start, TempList),
        NewEnd is End - Start + 1,
        take(TempList, NewEnd, NewList).

% Given a board and cube number, gets the corresponding cube as a list.
% Cubes are 3x3 portions, numbered from the top left to the bottom right,
% starting from 0.  For example, they would be numbered like so:
%
% 0  1  2
% 3  4  5
% 6  7  8
%
% getCube: (Board, CubeNumber, ContentsOfCube)
getCube(Board, Number, AsList) :-
        cubeBounds(RowLow, RowHigh, ColLow, ColHigh, Number),
        sublist(Board, RowLow, RowHigh, [Row1, Row2, Row3]),
        sublist(Row1, ColLow, ColHigh, Row1Nums),
        sublist(Row2, ColLow, ColHigh, Row2Nums),
        sublist(Row3, ColLow, ColHigh, Row3Nums),
        append(Row1Nums, Row2Nums, TempRow),
        append(TempRow, Row3Nums, AsList).


% Given a board, solve it in-place.
% After calling `solve` on a board, the board should be fully
% instantiated with a satisfying Sudoku solution.

% -------------------- PUT CODE HERE -------------------
% -------------------- PUT CODE HERE -------------------

% import the is_set/1 function
:- use_module(library(lists)).

% helper function to split list into 9 variables.
split([H | T], H, T).
splitRows(Board, A, B, C, D, E, F, G, H, I) :-
      split(Board, A, Arest),
      split(Arest, B, Brest),
      split(Brest, C, Crest),
      split(Crest, D, Drest),
      split(Drest, E, Erest),
      split(Erest, F, Frest),
      split(Frest, G, Grest),
      split(Grest, H, Hrest),
      split(Hrest, I, []).

solve(Board) :-
    % Introduce variables for each row.
    splitRows(Board, R0, R1, R2, R3, R4, R5, R6, R7, R8),

    % Introduce variables for each column.
    columnAsList(Board, 0, C0),
    columnAsList(Board, 1, C1),
    columnAsList(Board, 2, C2),
    columnAsList(Board, 3, C3),
    columnAsList(Board, 4, C4),
    columnAsList(Board, 5, C5),
    columnAsList(Board, 6, C6),
    columnAsList(Board, 7, C7),
    columnAsList(Board, 8, C8),

    % Introduce variables for each cube.
    getCube(Board, 0, Cub0),
    getCube(Board, 1, Cub1),
    getCube(Board, 2, Cub2),
    getCube(Board, 3, Cub3),
    getCube(Board, 4, Cub4),
    getCube(Board, 5, Cub5),
    getCube(Board, 6, Cub6),
    getCube(Board, 7, Cub7),
    getCube(Board, 8, Cub8),

    % Introduce variables for each square.
    splitRows(R0, S00, S01, S02, S03, S04, S05, S06, S07, S08),
    splitRows(R1, S10, S11, S12, S13, S14, S15, S16, S17, S18),
    splitRows(R2, S20, S21, S22, S23, S24, S25, S26, S27, S28),
    splitRows(R3, S30, S31, S32, S33, S34, S35, S36, S37, S38),
    splitRows(R4, S40, S41, S42, S43, S44, S45, S46, S47, S48),
    splitRows(R5, S50, S51, S52, S53, S54, S55, S56, S57, S58),
    splitRows(R6, S60, S61, S62, S63, S64, S65, S66, S67, S68),
    splitRows(R7, S70, S71, S72, S73, S74, S75, S76, S77, S78),
    splitRows(R8, S80, S81, S82, S83, S84, S85, S86, S87, S88),


    % Solve for each square, left to right, top to bottom.
    % Row 0.
    (nonvar(S00); var(S00), digit(S00), is_set(R0), is_set(C0), is_set(Cub0)),
    (nonvar(S01); var(S01), digit(S01), is_set(R0), is_set(C1), is_set(Cub0)),
    (nonvar(S02); var(S02), digit(S02), is_set(R0), is_set(C2), is_set(Cub0)),
    (nonvar(S03); var(S03), digit(S03), is_set(R0), is_set(C3), is_set(Cub1)),
    (nonvar(S04); var(S04), digit(S04), is_set(R0), is_set(C4), is_set(Cub1)),
    (nonvar(S05); var(S05), digit(S05), is_set(R0), is_set(C5), is_set(Cub1)),
    (nonvar(S06); var(S06), digit(S06), is_set(R0), is_set(C6), is_set(Cub2)),
    (nonvar(S07); var(S07), digit(S07), is_set(R0), is_set(C7), is_set(Cub2)),
    (nonvar(S08); var(S08), digit(S08), is_set(R0), is_set(C8), is_set(Cub2)),

    % Row 1.
    (nonvar(S10); var(S10), digit(S10), is_set(R1), is_set(C0), is_set(Cub0)),
    (nonvar(S11); var(S11), digit(S11), is_set(R1), is_set(C1), is_set(Cub0)),
    (nonvar(S12); var(S12), digit(S12), is_set(R1), is_set(C2), is_set(Cub0)),
    (nonvar(S13); var(S13), digit(S13), is_set(R1), is_set(C3), is_set(Cub1)),
    (nonvar(S14); var(S14), digit(S14), is_set(R1), is_set(C4), is_set(Cub1)),
    (nonvar(S15); var(S15), digit(S15), is_set(R1), is_set(C5), is_set(Cub1)),
    (nonvar(S16); var(S16), digit(S16), is_set(R1), is_set(C6), is_set(Cub2)),
    (nonvar(S17); var(S17), digit(S17), is_set(R1), is_set(C7), is_set(Cub2)),
    (nonvar(S18); var(S18), digit(S18), is_set(R1), is_set(C8), is_set(Cub2)),

    % Row 2.
    (nonvar(S20); var(S20), digit(S20), is_set(R2), is_set(C0), is_set(Cub0)),
    (nonvar(S21); var(S21), digit(S21), is_set(R2), is_set(C1), is_set(Cub0)),
    (nonvar(S22); var(S22), digit(S22), is_set(R2), is_set(C2), is_set(Cub0)),
    (nonvar(S23); var(S23), digit(S23), is_set(R2), is_set(C3), is_set(Cub1)),
    (nonvar(S24); var(S24), digit(S24), is_set(R2), is_set(C4), is_set(Cub1)),
    (nonvar(S25); var(S25), digit(S25), is_set(R2), is_set(C5), is_set(Cub1)),
    (nonvar(S26); var(S26), digit(S26), is_set(R2), is_set(C6), is_set(Cub2)),
    (nonvar(S27); var(S27), digit(S27), is_set(R2), is_set(C7), is_set(Cub2)),
    (nonvar(S28); var(S28), digit(S28), is_set(R2), is_set(C8), is_set(Cub2)),

    % Row 3.
    (nonvar(S30); var(S30), digit(S30), is_set(R3), is_set(C0), is_set(Cub3)),
    (nonvar(S31); var(S31), digit(S31), is_set(R3), is_set(C1), is_set(Cub3)),
    (nonvar(S32); var(S32), digit(S32), is_set(R3), is_set(C2), is_set(Cub3)),
    (nonvar(S33); var(S33), digit(S33), is_set(R3), is_set(C3), is_set(Cub4)),
    (nonvar(S34); var(S34), digit(S34), is_set(R3), is_set(C4), is_set(Cub4)),
    (nonvar(S35); var(S35), digit(S35), is_set(R3), is_set(C5), is_set(Cub4)),
    (nonvar(S36); var(S36), digit(S36), is_set(R3), is_set(C6), is_set(Cub5)),
    (nonvar(S37); var(S37), digit(S37), is_set(R3), is_set(C7), is_set(Cub5)),
    (nonvar(S38); var(S38), digit(S38), is_set(R3), is_set(C8), is_set(Cub5)),

    % Row 4.
    (nonvar(S40); var(S40), digit(S40), is_set(R4), is_set(C0), is_set(Cub3)),
    (nonvar(S41); var(S41), digit(S41), is_set(R4), is_set(C1), is_set(Cub3)),
    (nonvar(S42); var(S42), digit(S42), is_set(R4), is_set(C2), is_set(Cub3)),
    (nonvar(S43); var(S43), digit(S43), is_set(R4), is_set(C3), is_set(Cub4)),
    (nonvar(S44); var(S44), digit(S44), is_set(R4), is_set(C4), is_set(Cub4)),
    (nonvar(S45); var(S45), digit(S45), is_set(R4), is_set(C5), is_set(Cub4)),
    (nonvar(S46); var(S46), digit(S46), is_set(R4), is_set(C6), is_set(Cub5)),
    (nonvar(S47); var(S47), digit(S47), is_set(R4), is_set(C7), is_set(Cub5)),
    (nonvar(S48); var(S48), digit(S48), is_set(R4), is_set(C8), is_set(Cub5)),

    % Row 5.
    (nonvar(S50); var(S50), digit(S50), is_set(R5), is_set(C0), is_set(Cub3)),
    (nonvar(S51); var(S51), digit(S51), is_set(R5), is_set(C1), is_set(Cub3)),
    (nonvar(S52); var(S52), digit(S52), is_set(R5), is_set(C2), is_set(Cub3)),
    (nonvar(S53); var(S53), digit(S53), is_set(R5), is_set(C3), is_set(Cub4)),
    (nonvar(S54); var(S54), digit(S54), is_set(R5), is_set(C4), is_set(Cub4)),
    (nonvar(S55); var(S55), digit(S55), is_set(R5), is_set(C5), is_set(Cub4)),
    (nonvar(S56); var(S56), digit(S56), is_set(R5), is_set(C6), is_set(Cub5)),
    (nonvar(S57); var(S57), digit(S57), is_set(R5), is_set(C7), is_set(Cub5)),
    (nonvar(S58); var(S58), digit(S58), is_set(R5), is_set(C8), is_set(Cub5)),

    % Row 6.
    (nonvar(S60); var(S60), digit(S60), is_set(R6), is_set(C0), is_set(Cub6)),
    (nonvar(S61); var(S61), digit(S61), is_set(R6), is_set(C1), is_set(Cub6)),
    (nonvar(S62); var(S62), digit(S62), is_set(R6), is_set(C2), is_set(Cub6)),
    (nonvar(S63); var(S63), digit(S63), is_set(R6), is_set(C3), is_set(Cub7)),
    (nonvar(S64); var(S64), digit(S64), is_set(R6), is_set(C4), is_set(Cub7)),
    (nonvar(S65); var(S65), digit(S65), is_set(R6), is_set(C5), is_set(Cub7)),
    (nonvar(S66); var(S66), digit(S66), is_set(R6), is_set(C6), is_set(Cub8)),
    (nonvar(S67); var(S67), digit(S67), is_set(R6), is_set(C7), is_set(Cub8)),
    (nonvar(S68); var(S68), digit(S68), is_set(R6), is_set(C8), is_set(Cub8)),

    % Row 7.
    (nonvar(S70); var(S70), digit(S70), is_set(R7), is_set(C0), is_set(Cub6)),
    (nonvar(S71); var(S71), digit(S71), is_set(R7), is_set(C1), is_set(Cub6)),
    (nonvar(S72); var(S72), digit(S72), is_set(R7), is_set(C2), is_set(Cub6)),
    (nonvar(S73); var(S73), digit(S73), is_set(R7), is_set(C3), is_set(Cub7)),
    (nonvar(S74); var(S74), digit(S74), is_set(R7), is_set(C4), is_set(Cub7)),
    (nonvar(S75); var(S75), digit(S75), is_set(R7), is_set(C5), is_set(Cub7)),
    (nonvar(S76); var(S76), digit(S76), is_set(R7), is_set(C6), is_set(Cub8)),
    (nonvar(S77); var(S77), digit(S77), is_set(R7), is_set(C7), is_set(Cub8)),
    (nonvar(S78); var(S78), digit(S78), is_set(R7), is_set(C8), is_set(Cub8)),

    % Row 8.
    (nonvar(S80); var(S80), digit(S80), is_set(R8), is_set(C0), is_set(Cub6)),
    (nonvar(S81); var(S81), digit(S81), is_set(R8), is_set(C1), is_set(Cub6)),
    (nonvar(S82); var(S82), digit(S82), is_set(R8), is_set(C2), is_set(Cub6)),
    (nonvar(S83); var(S83), digit(S83), is_set(R8), is_set(C3), is_set(Cub7)),
    (nonvar(S84); var(S84), digit(S84), is_set(R8), is_set(C4), is_set(Cub7)),
    (nonvar(S85); var(S85), digit(S85), is_set(R8), is_set(C5), is_set(Cub7)),
    (nonvar(S86); var(S86), digit(S86), is_set(R8), is_set(C6), is_set(Cub8)),
    (nonvar(S87); var(S87), digit(S87), is_set(R8), is_set(C7), is_set(Cub8)),
    (nonvar(S88); var(S88), digit(S88), is_set(R8), is_set(C8), is_set(Cub8)).



% -------------------- PUT CODE HERE -------------------
% -------------------- PUT CODE HERE -------------------

% Prints out the given board.
printBoard([]).
printBoard([Head|Tail]) :-
        write(Head), nl,
        printBoard(Tail).

test1(Board) :-
        Board = [[2, _, _, _, 8, 7, _, 5, _],
                 [_, _, _, _, 3, 4, 9, _, 2],
                 [_, _, 5, _, _, _, _, _, 8],
                 [_, 6, 4, 2, 1, _, _, 7, _],
                 [7, _, 2, _, 6, _, 1, _, 9],
                 [_, 8, _, _, 7, 3, 2, 4, _],
                 [8, _, _, _, _, _, 4, _, _],
                 [3, _, 9, 7, 4, _, _, _, _],
                 [_, 1, _, 8, 2, _, _, _, 5]],
        solve(Board),
        printBoard(Board).

test2(Board) :-
        Board = [[_, _, _, 7, 9, _, 8, _, _],
                 [_, _, _, _, _, 4, 3, _, 7],
                 [_, _, _, 3, _, _, _, 2, 9],
                 [7, _, _, _, 2, _, _, _, _],
                 [5, 1, _, _, _, _, _, 4, 8],
                 [_, _, _, _, 5, _, _, _, 1],
                 [1, 2, _, _, _, 8, _, _, _],
                 [6, _, 4, 1, _, _, _, _, _],
                 [_, _, 3, _, 6, 2, _, _, _]],
        solve(Board),
        printBoard(Board).
