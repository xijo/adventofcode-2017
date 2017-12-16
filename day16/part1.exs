defmodule Promenade do
  def parse(str) do
    instructions = String.slice(str, 1..-1)
    case String.first(str) do
      "s" -> {"s", instructions |> String.to_integer }
      "x" -> {"x", instructions |> String.split("/") |> Enum.map(&String.to_integer/1) |> List.to_tuple }
      "p" -> {"p", instructions |> String.split("/") |> List.to_tuple }
    end
  end

  def move({"s", times}, programs), do: spin(programs, times)
  def move({_, {a, b}}, programs),  do: swap(programs, a, b)

  def spin(programs, 0), do: programs

  def spin(programs, times) do
    values = Map.values(programs)
    new_values = [List.last(values) | Enum.slice(values, 0..-2)]
    new_programs = new_values
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {v, i}, acc -> Map.put(acc, i, v) end)
    spin(new_programs, times - 1)
  end

  def swap(programs, p1, p2) when is_integer(p1) do
    programs
    |> Map.put(p1, programs[p2])
    |> Map.put(p2, programs[p1])
  end

  def swap(programs, a, b) do
    programs
    |> Map.put(Enum.find_index(programs, fn {_, v} -> v == a end), b)
    |> Map.put(Enum.find_index(programs, fn {_, v} -> v == b end), a)
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule PromenadeTest do
  use ExUnit.Case
  @programs %{0 => "a", 1 => "b", 2 => "c", 3 => "d", 4 => "e"}

  test "parse 1", do: assert Promenade.parse("s12")   == {"s", 12}
  test "parse 2", do: assert Promenade.parse("x3/14") == {"x", {3, 14}}
  test "parse 3", do: assert Promenade.parse("pa/b") ==  {"p", {"a", "b"}}

  test "spin 1", do: assert Promenade.spin(@programs, 2) |> Map.values |> Enum.join == "deabc"
  test "swap 1", do: assert Promenade.swap(@programs, 0, 2) |> Map.values |> Enum.join == "cbade"
  test "swap 2", do: assert Promenade.swap(@programs, "a", "b") |> Map.values |> Enum.join == "bacde"
end

acc = %{0 => "a", 1 => "b", 2 => "c", 3 => "d", 4 => "e", 5 => "f", 6 => "g", 7 => "h", 8 => "i", 9 => "j", 10 => "k", 11 => "l", 12 => "m", 13 => "n", 14 => "o", 15 => "p"}

instructions = File.read!("input.txt")
|> String.trim
|> String.split(",")
|> Enum.map(&Promenade.parse/1)
|> Enum.reduce(acc, &Promenade.move/2)
|> Map.values
|> Enum.join
|> IO.inspect
