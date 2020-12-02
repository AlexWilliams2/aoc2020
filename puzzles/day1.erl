%%%-------------------------------------------------------------------
%%% @author developer
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Dec 2020 16:48
%%%-------------------------------------------------------------------
-module(day1).
-author("Alex Williams").

%% API
-export([puzzle1/1, puzzle2/1, readlines/1]).

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

puzzle1(Filename) ->
    Input = readlines(Filename),
    BitList = re:split(Input, "\n"),
    NumList = lists:filtermap(fun(X) -> case X of <<>> -> false; _ -> {true, binary_to_integer(X)} end end, BitList),
    find_complements(2020, NumList).

puzzle2(Filename) ->
    Input = readlines(Filename),
    BitList = re:split(Input, "\n"),
    NumList = lists:filtermap(fun(X) -> case X of <<>> -> false; _ -> {true, binary_to_integer(X)} end end, BitList),
    find_triples(2020, NumList, NumList).

find_triples(Sum, [Head | NewList], OrigList) ->
    NewSum = Sum - Head,
    case find_complements(NewSum, OrigList) of
        false -> find_triples(Sum, NewList, OrigList);
        Other -> Head * Other
    end.

find_complements(Sum, [])->
    false;
find_complements(Sum, [Head | NumList]) ->
    case lists:member(Sum - Head, NumList) of
        true ->
            Head * (Sum - Head);
        false -> find_complements(Sum, NumList)
    end.
