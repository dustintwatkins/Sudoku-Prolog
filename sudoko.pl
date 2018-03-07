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

:- use_module(library(lists)).

%split helper function splits list into 9 variables
split([H | T], H, T).
splitRows(Board, A, B, C, D, E, F, G, H, I) :-
  split(Board,  A, Rest_A),
  split(Rest_A, B, Rest_B),
  split(Rest_B, C, Rest_C),
  split(Rest_C, D, Rest_D),
  split(Rest_D, E, Rest_E),
  split(Rest_E, F, Rest_F),
  split(Rest_F, G, Rest_G),
  split(Rest_G, H, Rest_H),
  split(Rest_H, I, []).

solve(Board) :-

  %Make variables for the rows
  splitRows(Board, Row_0, Row_1, Row_2, Row_3, Row_4, Row_5, Row_6, Row_7, Row_8),

  %Make variables for the coluns
  columnAsList(Board, 0, Col_0),
  columnAsList(Board, 1, Col_1),
  columnAsList(Board, 2, Col_2),
  columnAsList(Board, 3, Col_3),
  columnAsList(Board, 4, Col_4),
  columnAsList(Board, 5, Col_5),
  columnAsList(Board, 6, Col_6),
  columnAsList(Board, 7, Col_7),
  columnAsList(Board, 8, Col_8),

  %Make variables for the cube
  getCube(Board, 0, Cube_0),
  getCube(Board, 1, Cube_1),
  getCube(Board, 2, Cube_2),
  getCube(Board, 3, Cube_3),
  getCube(Board, 4, Cube_4),
  getCube(Board, 5, Cube_5),
  getCube(Board, 6, Cube_6),
  getCube(Board, 7, Cube_7),
  getCube(Board, 8, Cube_8),

  %Make variables for the Spaces
  splitRows(Row_0, Space00, Space01, Space02, Space03, Space04, Space05, Space06, Space07, Space08),
  splitRows(Row_1, Space10, Space11, Space12, Space13, Space14, Space15, Space16, Space17, Space18),
  splitRows(Row_2, Space20, Space21, Space22, Space23, Space24, Space25, Space26, Space27, Space28),
  splitRows(Row_3, Space30, Space31, Space32, Space33, Space34, Space35, Space36, Space37, Space38),
  splitRows(Row_4, Space40, Space41, Space42, Space43, Space44, Space45, Space46, Space47, Space48),
  splitRows(Row_5, Space50, Space51, Space52, Space53, Space54, Space55, Space56, Space57, Space58),
  splitRows(Row_6, Space60, Space61, Space62, Space63, Space64, Space65, Space66, Space67, Space68),
  splitRows(Row_7, Space70, Space71, Space72, Space73, Space74, Space75, Space76, Space77, Space78),
  splitRows(Row_8, Space80, Space81, Space82, Space83, Space84, Space85, Space86, Space87, Space88),

  %solve Row_0, columns 0-8, top three cubes (0-2)
  (nonvar(Space00); var(Space00), digit(Space00), is_set(Row_0), is_set(Col_0), is_set(Cube_0)),
  (nonvar(Space01); var(Space01), digit(Space01), is_set(Row_0), is_set(Col_1), is_set(Cube_0)),
  (nonvar(Space02); var(Space02), digit(Space02), is_set(Row_0), is_set(Col_2), is_set(Cube_0)),
  (nonvar(Space03); var(Space03), digit(Space03), is_set(Row_0), is_set(Col_3), is_set(Cube_1)),
  (nonvar(Space04); var(Space04), digit(Space04), is_set(Row_0), is_set(Col_4), is_set(Cube_1)),
  (nonvar(Space05); var(Space05), digit(Space05), is_set(Row_0), is_set(Col_5), is_set(Cube_1)),
  (nonvar(Space06); var(Space06), digit(Space06), is_set(Row_0), is_set(Col_6), is_set(Cube_2)),
  (nonvar(Space07); var(Space07), digit(Space07), is_set(Row_0), is_set(Col_7), is_set(Cube_2)),
  (nonvar(Space08); var(Space08), digit(Space08), is_set(Row_0), is_set(Col_8), is_set(Cube_2)),

  %solve Row_1, columns 0-8, top three cubes (0-2)
  (nonvar(Space10); var(Space10), digit(Space10), is_set(Row_1), is_set(Col_0), is_set(Cube_0)),
  (nonvar(Space11); var(Space11), digit(Space11), is_set(Row_1), is_set(Col_1), is_set(Cube_0)),
  (nonvar(Space12); var(Space12), digit(Space12), is_set(Row_1), is_set(Col_2), is_set(Cube_0)),
  (nonvar(Space13); var(Space13), digit(Space13), is_set(Row_1), is_set(Col_3), is_set(Cube_1)),
  (nonvar(Space14); var(Space14), digit(Space14), is_set(Row_1), is_set(Col_4), is_set(Cube_1)),
  (nonvar(Space15); var(Space15), digit(Space15), is_set(Row_1), is_set(Col_5), is_set(Cube_1)),
  (nonvar(Space16); var(Space16), digit(Space16), is_set(Row_1), is_set(Col_6), is_set(Cube_2)),
  (nonvar(Space17); var(Space17), digit(Space17), is_set(Row_1), is_set(Col_7), is_set(Cube_2)),
  (nonvar(Space18); var(Space18), digit(Space18), is_set(Row_1), is_set(Col_8), is_set(Cube_2)),

  %solve Row_2 columns 0-8, top three cubes(0-2)
  (nonvar(Space20); var(Space20), digit(Space20), is_set(Row_2), is_set(Col_0), is_set(Cube_0)),
  (nonvar(Space21); var(Space21), digit(Space21), is_set(Row_2), is_set(Col_1), is_set(Cube_0)),
  (nonvar(Space22); var(Space22), digit(Space22), is_set(Row_2), is_set(Col_2), is_set(Cube_0)),
  (nonvar(Space23); var(Space23), digit(Space23), is_set(Row_2), is_set(Col_3), is_set(Cube_1)),
  (nonvar(Space24); var(Space24), digit(Space24), is_set(Row_2), is_set(Col_4), is_set(Cube_1)),
  (nonvar(Space25); var(Space25), digit(Space25), is_set(Row_2), is_set(Col_5), is_set(Cube_1)),
  (nonvar(Space26); var(Space26), digit(Space26), is_set(Row_2), is_set(Col_6), is_set(Cube_2)),
  (nonvar(Space27); var(Space27), digit(Space27), is_set(Row_2), is_set(Col_7), is_set(Cube_2)),
  (nonvar(Space28); var(Space28), digit(Space28), is_set(Row_2), is_set(Col_8), is_set(Cube_2)),

  %solve Row_3 columns 0-8, middle three cubes(3-5)
  (nonvar(Space30); var(Space30), digit(Space30), is_set(Row_3), is_set(Col_0), is_set(Cube_3)),
  (nonvar(Space31); var(Space31), digit(Space31), is_set(Row_3), is_set(Col_1), is_set(Cube_3)),
  (nonvar(Space32); var(Space32), digit(Space32), is_set(Row_3), is_set(Col_2), is_set(Cube_3)),
  (nonvar(Space33); var(Space33), digit(Space33), is_set(Row_3), is_set(Col_3), is_set(Cube_4)),
  (nonvar(Space34); var(Space34), digit(Space34), is_set(Row_3), is_set(Col_4), is_set(Cube_4)),
  (nonvar(Space35); var(Space35), digit(Space35), is_set(Row_3), is_set(Col_5), is_set(Cube_4)),
  (nonvar(Space36); var(Space36), digit(Space36), is_set(Row_3), is_set(Col_6), is_set(Cube_5)),
  (nonvar(Space37); var(Space37), digit(Space37), is_set(Row_3), is_set(Col_7), is_set(Cube_5)),
  (nonvar(Space38); var(Space38), digit(Space38), is_set(Row_3), is_set(Col_8), is_set(Cube_5)),

  %solve Row_4 columns 0-8, middle three cubes(3-5)
  (nonvar(Space40); var(Space40), digit(Space40), is_set(Row_4), is_set(Col_0), is_set(Cube_3)),
  (nonvar(Space41); var(Space41), digit(Space41), is_set(Row_4), is_set(Col_1), is_set(Cube_3)),
  (nonvar(Space42); var(Space42), digit(Space42), is_set(Row_4), is_set(Col_2), is_set(Cube_3)),
  (nonvar(Space43); var(Space43), digit(Space43), is_set(Row_4), is_set(Col_3), is_set(Cube_4)),
  (nonvar(Space44); var(Space44), digit(Space44), is_set(Row_4), is_set(Col_4), is_set(Cube_4)),
  (nonvar(Space45); var(Space45), digit(Space45), is_set(Row_4), is_set(Col_5), is_set(Cube_4)),
  (nonvar(Space46); var(Space46), digit(Space46), is_set(Row_4), is_set(Col_6), is_set(Cube_5)),
  (nonvar(Space47); var(Space47), digit(Space47), is_set(Row_4), is_set(Col_7), is_set(Cube_5)),
  (nonvar(Space48); var(Space48), digit(Space48), is_set(Row_4), is_set(Col_8), is_set(Cube_5)),

  %solve Row_5 columns 0-8, middle three cubes(3-5)
  (nonvar(Space50); var(Space50), digit(Space50), is_set(Row_5), is_set(Col_0), is_set(Cube_3)),
  (nonvar(Space51); var(Space51), digit(Space51), is_set(Row_5), is_set(Col_1), is_set(Cube_3)),
  (nonvar(Space52); var(Space52), digit(Space52), is_set(Row_5), is_set(Col_2), is_set(Cube_3)),
  (nonvar(Space53); var(Space53), digit(Space53), is_set(Row_5), is_set(Col_3), is_set(Cube_4)),
  (nonvar(Space54); var(Space54), digit(Space54), is_set(Row_5), is_set(Col_4), is_set(Cube_4)),
  (nonvar(Space55); var(Space55), digit(Space55), is_set(Row_5), is_set(Col_5), is_set(Cube_4)),
  (nonvar(Space56); var(Space56), digit(Space56), is_set(Row_5), is_set(Col_6), is_set(Cube_5)),
  (nonvar(Space57); var(Space57), digit(Space57), is_set(Row_5), is_set(Col_7), is_set(Cube_5)),
  (nonvar(Space58); var(Space58), digit(Space58), is_set(Row_5), is_set(Col_8), is_set(Cube_5)),

  %solve Row_6 columns 0-8, bottom three cubes(6-8)
  (nonvar(Space60); var(Space60), digit(Space60), is_set(Row_6), is_set(Col_0), is_set(Cube_6)),
  (nonvar(Space61); var(Space61), digit(Space61), is_set(Row_6), is_set(Col_1), is_set(Cube_6)),
  (nonvar(Space62); var(Space62), digit(Space62), is_set(Row_6), is_set(Col_2), is_set(Cube_6)),
  (nonvar(Space63); var(Space63), digit(Space63), is_set(Row_6), is_set(Col_3), is_set(Cube_7)),
  (nonvar(Space64); var(Space64), digit(Space64), is_set(Row_6), is_set(Col_4), is_set(Cube_7)),
  (nonvar(Space65); var(Space65), digit(Space65), is_set(Row_6), is_set(Col_5), is_set(Cube_7)),
  (nonvar(Space66); var(Space66), digit(Space66), is_set(Row_6), is_set(Col_6), is_set(Cube_8)),
  (nonvar(Space67); var(Space67), digit(Space67), is_set(Row_6), is_set(Col_7), is_set(Cube_8)),
  (nonvar(Space68); var(Space68), digit(Space68), is_set(Row_6), is_set(Col_8), is_set(Cube_8)),

  %solve Row_7 columns 0-8, bottom three cubes(6-8)
  (nonvar(Space70); var(Space70), digit(Space70), is_set(Row_7), is_set(Col_0), is_set(Cube_6)),
  (nonvar(Space71); var(Space71), digit(Space71), is_set(Row_7), is_set(Col_1), is_set(Cube_6)),
  (nonvar(Space72); var(Space72), digit(Space72), is_set(Row_7), is_set(Col_2), is_set(Cube_6)),
  (nonvar(Space73); var(Space73), digit(Space73), is_set(Row_7), is_set(Col_3), is_set(Cube_7)),
  (nonvar(Space74); var(Space74), digit(Space74), is_set(Row_7), is_set(Col_4), is_set(Cube_7)),
  (nonvar(Space75); var(Space75), digit(Space75), is_set(Row_7), is_set(Col_5), is_set(Cube_7)),
  (nonvar(Space76); var(Space76), digit(Space76), is_set(Row_7), is_set(Col_6), is_set(Cube_8)),
  (nonvar(Space77); var(Space77), digit(Space77), is_set(Row_7), is_set(Col_7), is_set(Cube_8)),
  (nonvar(Space78); var(Space78), digit(Space78), is_set(Row_7), is_set(Col_8), is_set(Cube_8)),

  %solve Row_8 columns 0-8, bottom three cubes(6-8)
  (nonvar(Space80); var(Space80), digit(Space80), is_set(Row_8), is_set(Col_0), is_set(Cube_6)),
  (nonvar(Space81); var(Space81), digit(Space81), is_set(Row_8), is_set(Col_1), is_set(Cube_6)),
  (nonvar(Space82); var(Space82), digit(Space82), is_set(Row_8), is_set(Col_2), is_set(Cube_6)),
  (nonvar(Space83); var(Space83), digit(Space83), is_set(Row_8), is_set(Col_3), is_set(Cube_7)),
  (nonvar(Space84); var(Space84), digit(Space84), is_set(Row_8), is_set(Col_4), is_set(Cube_7)),
  (nonvar(Space85); var(Space85), digit(Space85), is_set(Row_8), is_set(Col_5), is_set(Cube_7)),
  (nonvar(Space86); var(Space86), digit(Space86), is_set(Row_8), is_set(Col_6), is_set(Cube_8)),
  (nonvar(Space87); var(Space87), digit(Space87), is_set(Row_8), is_set(Col_7), is_set(Cube_8)),
  (nonvar(Space88); var(Space88), digit(Space88), is_set(Row_8), is_set(Col_8), is_set(Cube_8)).


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
