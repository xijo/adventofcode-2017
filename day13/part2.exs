# Full rewrite, initial version was way to slow

defmodule Firewall do
  def severity(firewall) do
    firewall
    |> Enum.filter(&scanner_present?/1)
    |> Enum.reduce(0, fn {position, depth}, sum -> sum + position * depth end)
  end

  def loophole(firewall, delay \\ 0) do
    firewall
    |> Enum.any?(&scanner_present?(&1, delay))
    |> case do
      true -> loophole(firewall, delay + 1)
      false -> delay
    end
  end

  def scanner_present?({position, depth}, delay \\ 0) do
    rem(position + delay, 2 * (depth - 1)) == 0
  end

  def line_to_tuple(str) do
    String.split(str, ": ") |> Enum.map(&String.to_integer/1) |> List.to_tuple
  end

  def build(str) do
    str
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&line_to_tuple/1)
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule FirewallTest do
  use ExUnit.Case

  test "build 1" do
    assert Firewall.build("0: 3\n1: 2\n4: 4\n6: 4\n") == [{0, 3}, {1, 2}, {4, 4}, {6, 4}]
  end

  test "severity 1" do
    fw = Firewall.build("0: 3\n1: 2\n4: 4\n6: 4\n")
    assert Firewall.severity(fw) == 24
  end

  test "severity 2" do
    fw = Firewall.build("0: 3\n1: 2\n4: 4\n6: 4\n")
    assert Firewall.loophole(fw) == 10
  end
end

File.read!("input.txt")
|> Firewall.build
|> Firewall.loophole
|> IO.inspect
