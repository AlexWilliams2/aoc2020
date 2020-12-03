%%%-------------------------------------------------------------------
%%% @author developer
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Dec 2020 16:45
%%%-------------------------------------------------------------------
-module(day3).
-author("developer").

%% API
-export([puzzle1/0, puzzle2/0]).

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
    after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

parse_input(Lines) ->
    BitList = re:split(Lines, "\n"),
    lists:filtermap(fun(X) -> case X of <<>> -> false; _ -> {true, binary_to_list(X)} end end, BitList).

would_hit_tree(Line, Pos) ->
    case string:slice(Line, Pos rem 31, 1) of
        "#" -> true;
        "." -> false
    end.

check_lines([Head | Lines], Pos, Acc, Right, Down, Check_Line) ->
    NewPos = Pos rem 31,
    case Down of
        1 ->
            case would_hit_tree(Head, NewPos) of
                true -> check_lines(Lines, NewPos + Right, Acc + 1, Right, Down, Check_Line);
                false -> check_lines(Lines, NewPos + Right, Acc, Right, Down, Check_Line)
            end;
        2 ->
            case Check_Line of
                true ->
                    case would_hit_tree(Head, NewPos) of
                        true -> check_lines(Lines, NewPos + Right, Acc + 1, Right, Down, false);
                        false -> check_lines(Lines, NewPos + Right, Acc, Right, Down, false)
                    end;
                false ->
                    check_lines(Lines, NewPos, Acc, Right, Down, true)
            end
    end;
check_lines([], _Pos, Acc, _Right, _Down, _Check_Line) ->
    Acc.

puzzle1() ->
    Input = parse_input(readlines("./inputs/input3.txt")),
    check_lines(Input, 0, 0, 3, 1, true).

puzzle2() ->
    Input = parse_input(readlines("./inputs/input3.txt")),
    check_lines(Input, 0, 0, 1, 1, true) * check_lines(Input, 0, 0, 3, 1, true) * check_lines(Input, 0, 0, 5, 1, true) * check_lines(Input, 0, 0, 7, 1, true) * check_lines(Input, 0, 0, 1, 2, true).
