defmodule GarbageStream do
  def score(string) do
    string
    |> String.graphemes
    |> sum_depths(1)
  end

  def sum_depths([], _), do: 0

  def sum_depths(["!", _ | tail], depth), do: sum_depths(tail, depth)

  def sum_depths([head | tail], depth) do
    case head do
      "<" -> garbage(tail, depth)
      "{" -> sum_depths(tail, depth + 1) + depth
      "}" -> sum_depths(tail, depth - 1)
      "," -> sum_depths(tail, depth)
      _   -> sum_depths(tail, depth)
    end
  end

  def garbage(["!", _ | tail], depth), do: garbage(tail, depth)

  def garbage([head | tail], depth) do
    case head do
      ">" -> sum_depths(tail, depth)
      _   -> garbage(tail, depth)
    end
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule GarbageStreamTest do
  use ExUnit.Case

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
