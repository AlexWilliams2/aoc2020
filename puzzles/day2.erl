%%%-------------------------------------------------------------------
%%% @author developer
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Dec 2020 16:24
%%%-------------------------------------------------------------------
-module(day2).
-author("developer").

%% API
-export([readlines/1, puzzle1/0, puzzle2/0]).

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
    lists:filter(fun(X) -> case X of <<>> -> false; _ -> true end end, BitList).

check_line(Line) ->
    [Bound, Patt, Pass] = re:split(Line, " "),
    Letter = lists:nth(1, binary:split(Patt, [<<":">>])),
    [Lower, Upper] = lists:filtermap(fun(X) -> case X of <<>> -> false; _ -> {true, binary_to_integer(X)} end end, re:split(Bound, "-")),
    Occs = length(binary:split(Pass, [Letter], [global])) - 1,
    Upper >= Occs andalso Occs >= Lower.

check_lines([Line | Lines], 1) ->
    case check_line(Line) of
        true -> check_lines(Lines, 1, 1);
        false -> check_lines(Lines, 1, 0)
    end;
check_lines([Line | Lines], 2) ->
    case check_line2(Line) of
        true -> check_lines(Lines, 2, 1);
        false -> check_lines(Lines, 2, 0)
    end.
check_lines([Line | Lines], 1, Acc) ->
    case check_line(Line) of
        true ->
            check_lines(Lines, 1, Acc + 1);
        false -> check_lines(Lines, 1, Acc)
    end;
check_lines([Line | Lines], 2, Acc) ->
    case check_line2(Line) of
        true ->
            check_lines(Lines, 2, Acc + 1);
        false -> check_lines(Lines, 2, Acc)
    end;
check_lines([], _, Acc) ->
    Acc.

%% Eww. I wish erlang had the same string processing capabilities as python...
check_line2(Line) ->
    [Pos, Patt, Pass] = re:split(Line, " "),
    Letter = binary_to_list(lists:nth(1, binary:split(Patt, [<<":">>]))),
    [Pos1, Pos2] = lists:filtermap(fun(X) -> case X of <<>> -> false; _ -> {true, binary_to_integer(X)} end end, re:split(Pos, "-")),
    SPass = binary_to_list(Pass),
    case string:slice(SPass, Pos1 - 1, 1) of
        Letter ->
            case string:slice(SPass, Pos2 - 1, 1) of
                Letter -> false;
                _ -> true
            end;
        _ ->
            case string:slice(SPass, Pos2 - 1, 1) of
                Letter -> true;
                _ -> false
            end
    end.

puzzle1() ->
    File = "./inputs/input2.txt",
    Lines = parse_input(readlines(File)),
    check_lines(Lines, 1).

puzzle2() ->
    File = ("./inputs/input2.txt"),
    Lines = parse_input(readlines(File)),
    check_lines(Lines, 2).