defmodule Grid do
  def read(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(%{}, fn({line, index}, acc) ->
      line = line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce(%{}, fn {c, i}, a -> Map.put a, i, c end)
      Map.put acc, index, line
    end)
  end
end
