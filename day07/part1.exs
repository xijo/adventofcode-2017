# Idea: find the only string that occurs exactly once
input = File.read!("input.txt") |> String.trim
list = Regex.scan(~r/[a-z]+/, input) |> List.flatten

list
|> Enum.find(fn(value) -> Enum.count(list, &(&1 == value)) == 1 end)
|> IO.inspect
