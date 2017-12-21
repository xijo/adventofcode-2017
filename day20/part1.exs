defmodule Particle do
  def from_string(string) do
    [p, v, a] = Regex.run ~r/p=<(.+)>, v=<(.+)>, a=<(.+)>/, string, capture: :all_but_first
    {to_tuple(p), to_tuple(v), to_tuple(a)}
  end

  def to_tuple(string) do
    string
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

  def move(particle, distance \\ 0, steps \\ 10000)

  def move(_, distance, 0), do: distance

  def move({p, v, a}, distance, steps) do
    # IO.inspect "p=<#{Tuple.to_list(p) |> Enum.join(",")}> v=<#{Tuple.to_list(v) |> Enum.join(",")}> a=<#{Tuple.to_list(a) |> Enum.join(",")}>"
    new_distance = distance + manhattan(p)
    new_velocity = add(v, a)
    new_point    = add(p, new_velocity)

    move({new_point, new_velocity, a}, new_distance, steps - 1)
  end

  def add({ax, ay, az}, {bx, by, bz}) do
    {ax + bx, ay + by, az + bz}
  end

  def manhattan({x, y, z}), do: abs(x) + abs(y) + abs(z)
end

# File.read!("sample.txt")
File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(&Particle.from_string/1)
|> Enum.map(&Particle.move/1)
|> Enum.with_index
|> Enum.min_by(fn {distance, _} -> distance end)
|> IO.inspect
