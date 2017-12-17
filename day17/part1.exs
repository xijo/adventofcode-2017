defmodule Spinlock do
  def spin {buffer, steps} do
    previous = Enum.max(buffer)
    position = Enum.find_index(buffer, fn x -> x == previous end)
    new_position = rem(position + steps, length(buffer))
    new_buffer = List.insert_at(buffer, new_position + 1, previous + 1)
    {new_buffer, steps}
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule SpinlockTest do
  use ExUnit.Case

  test "spin 1", do: assert Spinlock.spin({[0], 3}) == {[0, 1], 3}
  test "spin 2", do: assert Spinlock.spin({[0, 1], 3}) == {[0, 2, 1], 3}
  test "spin 3", do: assert Spinlock.spin({[0, 2, 1], 3}) == {[0, 2, 3, 1], 3}
  test "spin 4", do: assert Spinlock.spin({[0, 2, 3, 1], 3}) == {[0, 2, 4, 3, 1], 3}
end

{result, _} = 0..2018
|> Enum.reduce({[0], 366}, fn(i, acc) -> Spinlock.spin(acc) end)

index = result |> Enum.find_index(fn(x) -> x == 2017 end)
|> IO.inspect

result |> Enum.at(index + 1)
|> IO.inspect
