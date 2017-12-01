defmodule Captcha do
  # OK, here is the plan:
  # Find all digits that occur again in halfway-distance.
  # Since the given string should be rotated, it is duplicated (123 -> 123123).
  # This is why the positive lookahead needs to check the distance to the end
  # of the string as well.
  # http://rubular.com/r/jP5DXZsZSb
  def find_halfway_duplicates(str) do
    halfway = round(String.length(str) / 2)
    circle  = Enum.join([str, str])
    Regex.scan(~r/(\d)(?=.{#{halfway - 1}}\1.{#{halfway},}\z)/, circle)
  end
end

IO.inspect File.read!("input.txt")
  |> String.trim
  |> Captcha.find_halfway_duplicates
  |> Enum.map(&Enum.uniq/1)
  |> List.flatten
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum
