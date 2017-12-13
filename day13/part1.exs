defmodule Firewall do
  def build(string) do
    string
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&line_to_tuple/1)
    |> Enum.reduce(%{}, fn({position, depth}, fw) -> Map.put(fw, position, {depth, 0, :down}) end)
  end

  def line_to_tuple(str) do
    String.split(str, ": ") |> Enum.map(&String.to_integer/1) |> List.to_tuple
  end

  def move_scanners(firewall) do
    Enum.reduce(firewall, firewall, fn({k, v}, fw) ->
      Map.replace(fw, k, move_scanner(v))
    end)
  end

  def move_scanner(nil), do: nil

  def move_scanner({depth, scanner, :up}) do
    {depth, scanner - 1, if (scanner - 2) == -1 do :down else :up end}
  end

  def move_scanner({depth, scanner, :down}) do
    {depth, scanner + 1, if (scanner + 2) == depth do :up else :down end}
  end

  def severity(firewall) do
    passthrough_time = Map.keys(firewall) |> Enum.max

    {_, result} = Enum.reduce(0..passthrough_time, {firewall, 0}, fn(position, {fw, total}) ->
      total = total + increase_severity(fw, position)
      {move_scanners(fw), total}
    end)

    result
  end

  def increase_severity(firewall, position) do
    if firewall[position] do
      {depth, scanner, _} = firewall[position]
      if scanner == 0 do
        depth * position
      else
        0
      end
    else
      0
    end
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule FirewallTest do
  use ExUnit.Case

  test "move_scanner 1", do: assert Firewall.move_scanner({3, 0, :down}) == {3, 1, :down}
  test "move_scanner 2", do: assert Firewall.move_scanner({3, 1, :down}) == {3, 2, :up}
  test "move_scanner 3", do: assert Firewall.move_scanner({3, 2, :up})   == {3, 1, :up}
  test "move_scanner 4", do: assert Firewall.move_scanner({3, 1, :up})   == {3, 0, :down}
  test "move_scanner 5", do: assert Firewall.move_scanner({3, 0, :down}) == {3, 1, :down}
  test "move_scanner 6", do: assert Firewall.move_scanner(nil) == nil

  test "move_scanners 1" do
    assert Firewall.move_scanners(%{0 => {3,0,:down}, 1 => {2,0,:down}}) == %{0 => {3,1,:down}, 1 => {2,1,:up}}
  end

  test "severity 1" do
    fw = Firewall.build("0: 3\n1: 2\n4: 4\n6: 4\n")
    assert Firewall.severity(fw) == 24
  end
end

File.read!("input.txt")
|> Firewall.build
|> Firewall.severity
|> IO.inspect
