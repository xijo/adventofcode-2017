# Calculate checksum based on min_max of each line
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
    |> Enum.min_max
    |> Checksum.diff
  end

  def diff({a, b}) when a > b, do: a - b
  def diff({a, b}),            do: b - a
end

File.read!("input.txt")
  |> String.trim
  |> Checksum.document
  |> IO.inspect
