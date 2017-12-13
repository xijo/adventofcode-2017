defmodule Plumber do
  def read_line(line, hash) do
    [pos, connections] = String.split(line, " <-> ")
    put_in hash[pos], String.split(connections, ", ")
  end

  def is_connected?(_, _, []), do: false

  def is_connected?(map, seen, [head|tail]) do
    cond do
      Enum.member?(map[head], "0") ->
        true
      head == "0" ->
        true
      Enum.member?(seen, head) ->
        is_connected?(map, seen, tail)
      true ->
        seen = [head | seen]
        is_connected?(map, seen, tail ++ map[head])
    end
  end

  def gather_connections(key, village, connections \\ [])

  def gather_connection("0", village, connections) do
    connections
  end

  def gather_connections(key, village, connections) do
    Enum.reduce(village[key], connections, fn(ck, conns) ->
      conns = conns ++ [ck]
      if Enum.member?(conns, ck) do
        conns
      else
        conns ++ gather_connections(ck, village, conns) ++ [key]
      end
    end)
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule PlumberTest do
  use ExUnit.Case
  @example %{"0" => ["2"], "1" => ["1"], "2" => ["0", "3", "4"], "3" => ["2", "4"], "4" => ["2", "3", "6"], "5" => ["6"], "6" => ["4", "5"]}

  test "is_connected? 1", do: assert Plumber.is_connected?(@example, [], ["0"]) == true
  test "is_connected? 2", do: assert Plumber.is_connected?(@example, [], ["2"]) == true
  test "is_connected? 3", do: assert Plumber.is_connected?(@example, [], ["1"]) == false
end

village = File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.reduce(%{}, &Plumber.read_line/2)
|> IO.inspect

village
|> Enum.filter(fn({x, _}) -> Plumber.is_connected?(village, [], [x]) end)
|> length
|> IO.inspect
