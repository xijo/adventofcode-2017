defmodule HexGrid do
  def follow_path(path) do
    path
    |> String.trim
    |> String.split(",")
    |> Enum.reduce({0,0,0,0}, &HexGrid.move/2)
  end

  def move(direction, {x,y,z,max}) do
    result = case direction do
      "n"  -> { x  , y+1, z-1, max }
      "ne" -> { x+1, y  , z-1, max }
      "se" -> { x+1, y-1, z  , max }
      "s"  -> { x,   y-1, z+1, max }
      "sw" -> { x-1, y  , z+1, max }
      "nw" -> { x-1, y+1, z  , max }
    end
    if distance_to_center(result) > max do
      {foo_x, foo_y, foo_z, _} = result
      {foo_x, foo_y, foo_z, distance_to_center(result)}
    else
      result
    end
  end

  def distance_to_center({x,y,z,_}) do
    Enum.max([abs(x), abs(y), abs(z)])
  end
end

ExUnit.start
ExUnit.configure trace: true

File.read!("input.txt")
|> HexGrid.follow_path
|> IO.inspect
