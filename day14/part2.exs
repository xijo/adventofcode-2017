Code.require_file("../day10/part2.exs")

defmodule Defrag do
  def to_binary_map(string) do
    string
    |> String.graphemes
    |> Enum.map(fn c ->
      {i, _} = Integer.parse(c, 16)
      Integer.digits(i, 2)
      |> Enum.join
      |> String.pad_leading(4, "0")
      |> String.graphemes
    end)
    |> List.flatten
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {c, index}, acc ->
      Map.put acc, index, c
    end)
  end

  def used_spots(grid, size \\ 128) do
    range = 0..(size - 1)
    Enum.reduce(range, [], fn x, acc ->
      Enum.reduce(range, acc, fn y, acc ->
        if grid[x][y] == "1" do
          [{x,y} | acc]
        else
          acc
        end
      end)
    end)
  end

  def find_group(_, group, []) do
    group
  end

  def find_group(spots, group, [{x,y} | candidates]) do
    new_group = [{x,y} | group]

    new_candidates = candidates
    |> add_if_member(spots, {x,y+1})
    |> add_if_member(spots, {x,y-1})
    |> add_if_member(spots, {x+1,y})
    |> add_if_member(spots, {x-1,y})

    new_candidates = new_candidates -- new_group
    find_group(spots, new_group, new_candidates)
  end

  def add_if_member(candidates, spots, spot) do
    if Enum.member?(spots, spot) do
      [spot | candidates]
    else
      candidates
    end
  end

  def count_groups([], count) do
    count
  end

  def count_groups(spots, count) do
    new_spots = spots -- find_group(spots, [], [List.first(spots)])
    count_groups(new_spots, count + 1)
  end

  def grid(key, size \\ 128) do
    0..(size - 1)
    |> Enum.reduce(%{}, fn i, acc ->
      Map.put acc, i, KnotHash.hashsum(key <> "-#{i}") |> to_binary_map
    end)
  end
end

grid = Defrag.grid("wenycdww", 128)

spots = Defrag.used_spots(grid)

Defrag.count_groups(spots, 0)
|> IO.inspect
