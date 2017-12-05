defmodule Maze do
  def escape(list, position \\ 0, steps \\ 0) do
    cond do
      position >= length(list) -> steps
      position < 0             -> steps
      true ->
        jump = Enum.at(list, position)
        new_position = position + jump
        new_list = List.replace_at(list, position, jump + 1)
        escape(new_list, new_position, steps + 1)
    end
  end
end

# Maze.escape([0, 3, 0, 1, -3], 0, 0) |> IO.inspect

File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(&String.to_integer/1)
|> Maze.escape
|> IO.inspect
