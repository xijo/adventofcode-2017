defmodule Circus do
  def store_line(line, map) do
    [key, _ | rest] = line |> String.replace(",", "") |> String.split

    if length(rest) > 0 do
      ["->" | leaves] = rest
      Map.put_new(map, key, leaves)
    else
      Map.put_new(map, key, nil)
    end
  end
end

defmodule Tree do
  def add(map, key, structure) do
    if structure[key] do
      leaf = Enum.reduce(structure[key], %{}, fn(child, acc) -> add(acc, child, structure) end)
      Map.put_new(map, key, leaf)
    else
      Map.put_new(map, key, nil)
    end
  end

  def find_imbalance(map, weights) do
    keys_with_weight = map
    |> Map.keys
    |> Enum.map(fn(key) -> {key, sum(map[key], weights[key], weights)} end)
    |> Enum.group_by(fn {_, value} -> value end)

    if length(Map.keys(keys_with_weight)) > 1 do
      [{outlier_key, outlier_value}] = Map.values(keys_with_weight) |> Enum.min_by(&length/1)
      {_, normal_value} = Map.values(keys_with_weight) |> Enum.max_by(&length/1) |> List.first
      IO.inspect "#{outlier_key} (#{outlier_value}) differs from #{normal_value} by #{abs(outlier_value - normal_value)} and its own value is #{weights[outlier_key]} => change it to #{weights[outlier_key] + normal_value - outlier_value}"
      find_imbalance(map[outlier_key], weights)
    end
  end

  def sum(nil, value, _) do
    value
  end

  def sum(map, value, weights) do
    key_weight = Map.keys(map) |> Enum.map(&(weights[&1])) |> Enum.sum
    leaf_weight = Map.values(map) |> Enum.map(&(sum(&1, 0, weights))) |> Enum.sum
    value + key_weight + leaf_weight
  end
end

weights = File.read!("input.txt")
|> String.trim
|> (&Regex.scan(~r/([a-z]+)\s\((\d+)/, &1, capture: :all_but_first)).()
|> Enum.reduce(%{}, fn([key, value], acc) -> Map.put_new(acc, key, String.to_integer(value)) end)
# |> IO.inspect

structure = File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.reduce(%{}, fn(line, acc) -> Circus.store_line(line, acc) end)
# |> IO.inspect

tree = %{}
|> Tree.add("svugo", structure)

Tree.find_imbalance(tree["svugo"], weights)
