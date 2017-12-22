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

  def at(grid, {x,y}) do
    row = grid[x] || %{}
    row[y]
  end

  def put(grid, {x,y}, value) do
    row = grid[x] || %{}
    Map.put grid, x, Map.put(row, y, value)
  end
end
