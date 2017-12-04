defmodule Passphrase do
  def valid?(str) do
    String.split(str)
    |> duplicate_free
  end

  defp duplicate_free([head | tail]) do
    if Enum.member?(tail, head) do
      false
    else
      duplicate_free(tail)
    end
  end

  defp duplicate_free([]), do: true
end

File.read!("input.txt")
|> String.trim
|> String.split("\n")
|> Enum.filter(&Passphrase.valid?(&1))
|> length
|> IO.inspect
