defmodule GarbageStream do
  def score(string) do
    {transform, _} = string
    |> String.trim
    |> String.graphemes
    |> filter("")
    |> String.replace(~r/\[,+/, "[")
    |> Code.eval_string

    GarbageStream.sum(transform, 1)
  end

  def filter([], groups) do
    groups
  end

  def filter(["!" | tail], groups), do: ignore(tail, groups)
  def filter(["<" | tail], groups), do: garbage(tail, groups)
  def filter(["," | tail], groups), do: filter(tail, groups <> ",")
  def filter(["{" | tail], groups), do: filter(tail, groups <> "[")
  def filter(["}" | tail], groups), do: filter(tail, groups <> "]")
  def filter([_ | tail], groups), do: filter(tail, groups)

  def ignore([_ | tail], groups), do: filter(tail, groups)

  def ignore_garbage([_ | tail], groups), do: garbage(tail, groups)

  def garbage(["!" | tail], groups), do: ignore_garbage(tail, groups)
  def garbage([">" | tail], groups), do: filter(tail, groups)
  def garbage([_ | tail], groups), do: garbage(tail, groups)

  def sum([], depth) do
    depth
  end

  def sum(el, depth) when is_list(el) do
    depth + Enum.reduce(el, 0, fn(l, t) -> sum(l, depth + 1) + t end)
  end

  def sum(_, _) do
    0
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule GarbageStreamTest do
  use ExUnit.Case

  test "sum []",        do: assert GarbageStream.sum([], 1) == 1
  test "sum [\"a\"]",   do: assert GarbageStream.sum(["a"], 1) == 1
  test "sum [[]]",      do: assert GarbageStream.sum([[]], 1) == 3
  test "sum [[],[]]",   do: assert GarbageStream.sum([[],[]], 1) == 5
  test "sum [[[]]]",    do: assert GarbageStream.sum([[[]]], 1) == 6

  test "score {}" do
    assert GarbageStream.score("{}") == 1
  end

  test "score {{{}}}" do
    assert GarbageStream.score("{{{}}}") == 6
  end

  test "score {{},{}}" do
    assert GarbageStream.score("{{},{}}") == 5
  end

  test "score {{{},{},{{}}}}" do
    assert GarbageStream.score("{{{},{},{{}}}}") == 16
  end

  test "score {<a>,<a>,<a>,<a>}" do
    assert GarbageStream.score("{<a>,<a>,<a>,<a>}") == 1
  end

  test "score {{<ab>},{<ab>},{<ab>},{<ab>}}" do
    assert GarbageStream.score("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
  end

  test "score {{<!!>},{<!!>},{<!!>},{<!!>}}" do
    assert GarbageStream.score("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
  end

  test "score {{<a!>},{<a!>},{<a!>},{<ab>}}" do
    assert GarbageStream.score("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
  end
end

File.read!("input.txt")
|> GarbageStream.score
|> IO.inspect
