defmodule Virus do
  def infect(grid, point, direction, steps, infections \\ 0)

  def infect(_, _, _, 0, infections) do
    IO.inspect infections
  end

  def infect(grid, point, direction, steps, infections) do
    case Grid.at(grid, point) do
      "#" ->
        new_direction = turn(:right, direction)
        new_grid = Grid.put(grid, point, ".")
        new_point = move(point, new_direction)
        infect(new_grid, new_point, new_direction, steps - 1, infections)
      _ ->
        new_direction = turn(:left, direction)
        new_grid = Grid.put(grid, point, "#")
        new_point = move(point, new_direction)
        infect(new_grid, new_point, new_direction, steps - 1, infections + 1)
    end
  end

  def print(grid) do
    Enum.each(grid, fn {_, row} -> IO.puts(Map.values(row) |> Enum.map(fn(x) -> if x, do: x, else: "." end) |> Enum.join) end)
  end

  def turn(:left, :right), do: :up
  def turn(:left, :up),    do: :left
  def turn(:left, :left),  do: :down
  def turn(:left, :down),  do: :right
  def turn(:right, :right), do: :down
  def turn(:right, :down),  do: :left
  def turn(:right, :left),  do: :up
  def turn(:right, :up),    do: :right

  def move({x, y}, direction) do
    case direction do
      :down  -> {x+1, y}
      :up    -> {x-1, y}
      :right -> {x, y+1}
      :left  -> {x, y-1}
    end
  end
end

Code.require_file("../lib/grid.exs")

Virus.infect(Grid.read("sample.txt"), {1,1}, :up, 10000)
Virus.infect(Grid.read("input.txt"), {12,12}, :up, 10000)
