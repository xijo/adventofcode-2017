defmodule Judge do
  use Bitwise

  def match?({a, b}) do
    binary_tail(a) == binary_tail(b)
  end

  def binary_tail(number) do
    number &&& 65535
  end
end

defmodule Generator do
  def next({previous, factor}) do
    result = rem(previous * factor, 2147483647)
    {result, {result, factor}}
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule GeneratorTest do
  use ExUnit.Case

  test "next 1", do: assert Generator.next({65, 16807}) == {1092455, {1092455, 16807}}

  test "match? 1", do: assert !Judge.match?({1092455, 430625591})
  test "match? 2", do: assert Judge.match?({245556042, 1431495498})

  test "binary_tail", do: assert Judge.binary_tail(245556042) == 58186
end

gen1 = Stream.unfold({618, 16807}, &Generator.next/1)
gen2 = Stream.unfold({814, 48271}, &Generator.next/1)

Stream.zip(gen1, gen2)
|> Enum.take(40_000_000)
|> Stream.filter(&Judge.match?/1)
|> Enum.to_list
|> length
|> IO.inspect
