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
    net[x][y]
  end

  def crumbs(net, point, direction, steps) do
    value = get(net, point)

    case value do
      "|" -> crumbs(net, move(point, direction), direction, steps + 1)
      "-" -> crumbs(net, move(point, direction), direction, steps + 1)
      "+" -> change_direction(net, point, direction, steps + 1)
      _   -> if get(net, move(point, direction)) |> present? do
             crumbs(net, move(point, direction), direction, steps + 1)
           else
             steps + 1
           end
    end
  end

  def change_direction_updown(net, point, steps) do
    down = move(point, :down)
    up = move(point, :up)
    if get(net, down) |> present? do
      crumbs(net, down, :down, steps)
    else
      crumbs(net, up, :up, steps)
    end
  end

  def change_direction_leftright(net, point, steps) do
    right = move(point, :right)
    left = move(point, :left)
    if get(net, right) |> present? do
      crumbs(net, right, :right, steps)
    else
      crumbs(net, left, :left, steps)
    end
  end

  def change_direction(net, point, :down, steps),  do: change_direction_leftright(net, point, steps)
  def change_direction(net, point, :up, steps),    do: change_direction_leftright(net, point, steps)
  def change_direction(net, point, :right, steps), do: change_direction_updown(net, point, steps)
  def change_direction(net, point, :left, steps), do: change_direction_updown(net, point, steps)

  def present?(""), do: false
  def present?(" "), do: false
  def present?(nil), do: false
  def present?(_), do: true
end

Code.require_file("../lib/grid.exs")

# net = Grid.read("sample.txt")
net = Grid.read("input.txt")

# Network.crumbs(net, {0,4}, :down, 0) |> IO.inspect
Network.crumbs(net, {0,59}, :down, 0) |> IO.inspect
