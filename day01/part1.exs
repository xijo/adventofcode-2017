defmodule Captcha do
  def append_first_char(str) do
    Enum.join([str, String.first(str)])
  end

  def find_direct_duplicates(str) do
    Regex.scan(~r/(\d)(?=\1)/, str)
  end
end

IO.inspect File.read!("input.txt")
  |> String.trim
  |> Captcha.append_first_char
  |> Captcha.find_direct_duplicates
  # |> (&Regex.scan(~r/(\d)(?=\1)/, &1)).()
  |> Enum.map(&Enum.uniq/1)
  |> List.flatten
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum
