defmodule Spinlock do
  def short(_, _, 50_000_000, last_zero) do
    last_zero
  end

  def short(steps, position, value, last_zero) do
    new_position = rem(position + steps, value)
    last_zero = if new_position == 0 do value else last_zero end
    short(steps, new_position + 1, value + 1, last_zero)
  end
end

Spinlock.short(366, 0, 1, 0)
|> IO.inspect
