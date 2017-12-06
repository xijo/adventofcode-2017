defmodule Mem do
  # Return how many steps are taken until the first collision occurs
  def steps_until_loop(config, previous_configs \\ []) do
    if Enum.member?(previous_configs, config) do
      length(previous_configs)
    else
      new_config = redistribute(config)
      IO.inspect new_config
      steps_until_loop(new_config, [config | previous_configs])
    end
  end

  # Takes a config as list, plucks the maximum and zeroes the position, then
  # redistributes the value by calling the `increase` function.
  def redistribute(config) do
    {max, index} = max_with_index(config, 0, {0, 0})

    config = List.replace_at(config, index, 0)
    increase(config, index + 1, max)
  end

  # Don't increase if nothing to increase is left
  def increase(list, _, 0), do: list

  # If the position is beyond the list limit, start at the beginning
  def increase(list, position, rest) when position >= length(list) do
    increase(list, 0, rest)
  end

  # Update the list by adding 1 to the given position, then move to the next
  # position
  def increase(list, position, rest) do
    new_list = List.update_at(list, position, &(&1 + 1))
    increase(new_list, position + 1, rest - 1)
  end

  # Implement my own max function, b/c list |> Enum.with_index |> Enum.max
  # returns the last elem with max value, not the first.
  # See https://stackoverflow.com/questions/47684771
  def max_with_index([], _, result), do: result

  def max_with_index([head | tail], current_index, {max, _}) when head > max do
    max_with_index(tail, current_index + 1, {head, current_index})
  end

  def max_with_index([_ | tail], current_index, result) do
    max_with_index(tail, current_index + 1, result)
  end
end

# "0 2 7 0"
File.read!("input.txt")
|> String.trim
|> String.split
|> Enum.map(&String.to_integer/1)
|> Mem.steps_until_loop
|> IO.inspect
