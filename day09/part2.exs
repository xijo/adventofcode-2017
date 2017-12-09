defmodule GarbageStream do
  def garbage_count(string) do
    string
    |> String.trim
    |> String.graphemes
    |> filter("", 0)

  end

  def filter([], groups, gc), do: gc

  def filter(["!" | tail], groups, gc), do: ignore(tail, groups, gc)
  def filter(["<" | tail], groups, gc), do: garbage(tail, groups, gc)
  def filter(["," | tail], groups, gc), do: filter(tail, groups <> ",", gc)
  def filter(["{" | tail], groups, gc), do: filter(tail, groups <> "[", gc)
  def filter(["}" | tail], groups, gc), do: filter(tail, groups <> "]", gc)
  def filter([_ | tail], groups, gc), do: filter(tail, groups, gc)

  def ignore([_ | tail], groups, gc), do: filter(tail, groups, gc)

  def ignore_garbage([_ | tail], groups, gc), do: garbage(tail, groups, gc)

  def garbage(["!" | tail], groups, gc), do: ignore_garbage(tail, groups, gc)
  def garbage([">" | tail], groups, gc), do: filter(tail, groups, gc)
  def garbage([_ | tail], groups, gc), do: garbage(tail, groups, gc+1)

end

ExUnit.start
ExUnit.configure trace: true

defmodule GarbageStreamTest do
  use ExUnit.Case

  test "garbage_count <random characters>" do
    assert GarbageStream.garbage_count("<random characters>") == 17
  end
end

File.read!("input.txt")
|> GarbageStream.garbage_count
|> IO.inspect
