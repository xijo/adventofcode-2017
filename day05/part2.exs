defmodule Maze do
  def escape(map, position \\ 0, steps \\ 0)

  def escape(map, position, steps) when position >= map_size(map)  do
    steps
  end

  def escape(_map, position, steps) when position < 0 do
    steps
  end

  def escape(map, position, steps) do
    offset       = map[position]
    new_position = position + offset
    new_offset   = offset + if offset >= 3 do -1 else 1 end
    map          = put_in map[position], new_offset
    escape(map, new_position, steps + 1)
  end
end

# Maze.escape([0, 3, 0, 1, -3], 0, 0) |> IO.inspect

File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(&String.to_integer/1)
|> Enum.with_index
|> Enum.map(fn {value, index} -> {index, value} end)
|> Map.new
|> Maze.escape
|> IO.inspect
