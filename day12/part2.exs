defmodule Plumber do
  def read_line(line, hash) do
    [pos, connections] = String.split(line, " <-> ")
    put_in hash[pos], String.split(connections, ", ")
  end

  def find_group(_, group, []) do
    group
  end

  def find_group(map, group, [head|tail]) do
    cond do
      Enum.member?(group, head) ->
        find_group(map, group, tail)
      true ->
        group = [head | group]
        find_group(map, group, tail ++ map[head])
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

village = File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.reduce(%{}, &Plumber.read_line/2)
|> IO.inspect

village
|> Enum.map(fn {x, _} -> Plumber.find_group(village, [], [x]) |> Enum.sort end)
|> Enum.uniq
|> length
|> IO.inspect
