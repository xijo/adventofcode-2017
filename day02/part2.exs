# Calculate checksum based on evenly divisible numbers
defmodule Checksum do
  def document(doc) do
    doc
    |> String.split("\n")
    |> Enum.map(&Checksum.line/1)
    |> Enum.sum
  end

  def line(line) do
    line
    |> String.split("\t")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort
    |> divisble_pair
    |> factor
  end

  defp divisble_pair([head | tail]) do
    dividend = Enum.find(tail, fn(d) -> rem(d, head) == 0 end)
    if dividend do
      {dividend, head}
    else
      divisble_pair(tail)
    end
  end

  def factor({a, b}) do
    round(a/b)
  end
end

File.read!("input.txt")
  |> String.trim
  |> Checksum.document
  |> IO.inspect
