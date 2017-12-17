Code.require_file("../day10/part2.exs")

defmodule Defrag do
  def sum_binary(string) do
    string
    |> String.graphemes
    |> Enum.map(fn c ->
      {i, _} = Integer.parse(c, 16)
      Integer.digits(i, 2)
      |> Enum.sum
    end)
    |> Enum.sum
  end

  def used_spaces(key) do
    0..127
    |> Enum.map(fn i ->
      key <> "-#{i}"
      |> KnotHash.hashsum
      |> sum_binary
    end)
    |> Enum.sum
  end
end

IO.inspect Defrag.used_spaces("wenycdww")
