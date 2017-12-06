defmodule Mem do
  # Return how many steps are taken until the first collision occurs
  def steps_between_loop(config, previous_configs \\ []) do
    if Enum.member?(previous_configs, config) do
      first_seen_at = Enum.find_index(Enum.reverse(previous_configs), &(&1 == config))
      length(previous_configs) - first_seen_at
    else
      new_config = redistribute(config)
      steps_between_loop(new_config, [config | previous_configs])
    end
  end

  # Takes a config as list, plucks the maximum and zeroes the position, then
  # redistributes the value by calling the `increase` function.
  def redistribute(config) do
    {max, index} = config |> Enum.with_index |> Enum.max_by(fn {x, _} -> x end)

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
end

# "0 2 7 0"
File.read!("input.txt")
|> String.trim
|> String.split
|> Enum.map(&String.to_integer/1)
|> Mem.steps_between_loop
|> IO.inspect
