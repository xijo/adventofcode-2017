defmodule Network do
  def move({x, y}, direction) do
    case direction do
      :down  -> {x+1, y}
      :up    -> {x-1, y}
      :right -> {x, y+1}
      :left  -> {x, y-1}
    end
  end

  def get(net, {x,y}) do
    net[x][y] |> to_string |> String.trim
  end

  def crumbs(net, point, direction, letters) do
    value = get(net, point)

    case value do
      "|" -> crumbs(net, move(point, direction), direction, letters)
      "-" -> crumbs(net, move(point, direction), direction, letters)
      "+" -> change_direction(net, point, direction, letters)
      _   -> if get(net, move(point, direction)) |> present? do
             crumbs(net, move(point, direction), direction, letters ++ [value])
           else
             Enum.join(letters ++ [value])
           end
    end
  end

  def change_direction(net, point, direction, letters) do
    cond do
      direction == :down || direction == :up ->
        right = move(point, :right)
        if get(net, right) |> present? do
          crumbs(net, right, :right, letters)
        else
          crumbs(net, move(point, :left), :left, letters)
        end
      true ->
        down = move(point, :down)
        if get(net, down) |> present? do
          crumbs(net, down, :down, letters)
        else
          crumbs(net, move(point, :up), :up, letters)
        end
    end
  end

  def present?(""), do: false
  def present?(" "), do: false
  def present?(nil), do: false
  def present?(_), do: true
end

net = File.read!("input.txt")
|> String.split("\n")
|> Enum.with_index
|> Enum.reduce(%{}, fn({line, index}, acc) ->
  line = line
  |> String.graphemes
  |> Enum.with_index
  |> Enum.reduce(%{}, fn {c, i}, a -> Map.put a, i, c end)
  Map.put acc, index, line
end)

# Network.crumbs(net, {0,4}, :down, []) |> IO.inspect
Network.crumbs(net, {0,59}, :down, []) |> IO.inspect
