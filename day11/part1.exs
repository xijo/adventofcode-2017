# https://www.redblobgames.com/grids/hexagons/#distances

defmodule HexGrid do
  def follow_path(path) do
    path
    |> String.trim
    |> String.split(",")
    |> Enum.reduce({0,0,0}, &HexGrid.move/2)
  end

  def move(direction, {x,y,z}) do
    case direction do
      "n"  -> { x  , y+1, z-1 }
      "ne" -> { x+1, y  , z-1 }
      "se" -> { x+1, y-1, z   }
      "s"  -> { x,   y-1, z+1 }
      "sw" -> { x-1, y  , z+1 }
      "nw" -> { x-1, y+1, z   }
    end
  end

  def distance_to_center({x,y,z}) do
    Enum.max([abs(x), abs(y), abs(z)])
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule HexGridTest do
  use ExUnit.Case

  test "move 1", do: assert HexGrid.move("se", {0, 0, 0}) == { 1, -1,  0}
  test "move 2", do: assert HexGrid.move("se", {3, 3, 3}) == { 4,  2,  3}

  test "distance_to_center 1", do: assert HexGrid.distance_to_center({3, 3, 3}) == 3
end

# "se,sw,se,sw,sw"
File.read!("input.txt")
|> HexGrid.follow_path
|> HexGrid.distance_to_center
|> IO.inspect
