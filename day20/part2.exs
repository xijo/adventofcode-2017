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

  def move({p, v, a}) do
    # IO.inspect "p=<#{Tuple.to_list(p) |> Enum.join(",")}> v=<#{Tuple.to_list(v) |> Enum.join(",")}> a=<#{Tuple.to_list(a) |> Enum.join(",")}>"
    new_velocity = add(v, a)
    new_point = add(p, new_velocity)
    {new_point, new_velocity, a}
  end

  def find_collision([]), do: nil

  def find_collision([head | tail]) do
    collisions = Enum.filter(tail, fn candidate -> collision?(head, candidate) end)

    if length(collisions) > 0 do
      [head | collisions]
    else
      find_collision(tail)
    end
  end

  def collision?({p1, _, _}, {p2, _, _}), do: p1 == p2

  def add({ax, ay, az}, {bx, by, bz}), do: {ax + bx, ay + by, az + bz}
end

# particles = File.read!("sample2.txt")
particles = File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(&Particle.from_string/1)

Enum.reduce(1..50, particles, fn(_, particles) ->
  particles = Enum.map(particles, &Particle.move/1)
  Enum.reduce_while(1..length(particles), particles, fn(_, particles) ->
    case collision = Particle.find_collision(particles) do
      nil -> {:halt, particles}
      _   -> {:cont, particles -- collision}
    end
  end)
end)
|> length
|> IO.inspect
