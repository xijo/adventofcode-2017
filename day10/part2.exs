defmodule KnotHash do
  require Bitwise

  def hashsum(string) do
    input = string |> String.to_charlist |> Enum.concat([17, 31, 73, 47, 23])
    list = 0..255 |> Enum.to_list

    rotate_by(list, input)
    |> Enum.chunk_every(16)
    |> Enum.map(fn(x) -> Enum.reduce(x, 0, &Bitwise.bxor/2) end)
    |> Enum.map(&(Integer.to_string(&1, 16) |> String.downcase |> String.pad_leading(2, "0")))
    |> Enum.join
  end

  def rotate_by(list, vector) do
    vector = zip_skips(vector)
    Enum.reduce(vector, list, fn({size, position}, list) -> rotate(list, position, size) end)
  end

  def zip_skips(list) do
    list = Stream.cycle(list) |> Enum.take(length(list) * 64)
    do_zip_skips(Enum.with_index(list), 0, length(list))
  end

  def do_zip_skips([{value, _}], current_position, _) do
    [{value, current_position}]
  end

  def do_zip_skips([{value, index} | tail], current_position, length) do
    [{value, current_position} | do_zip_skips(tail, current_position + value + index, length)]
  end

  def rotate(list, position, size) do
    position = rem(position, length(list))
    cond do
      position + size >= length(list) ->
        longerlist = list
        |> Stream.cycle
        |> Enum.take(position + size)
        |> Enum.reverse_slice(position, size)

        # Maybe use Enum.slice to do this splitting more elegantly
        {new_list, new_front} = Enum.split(longerlist, length(list))
        {_, new_list} = Enum.split(new_list, length(new_front))
        new_front ++ new_list
      true ->
        Enum.reverse_slice(list, position, size)
    end
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule KnotHashTest do
  use ExUnit.Case

  test "zip_skips 1", do: assert length(KnotHash.zip_skips([3, 4, 1, 5])) == 64 * 4

  test "hashsum 1", do: assert KnotHash.hashsum("") == "a2582a3a0e66e6e86e3812dcb672a272"

  test "rotate 2", do: assert KnotHash.rotate([1,2,3,4,5,6], 0, 4) == [4,3,2,1,5,6]
  test "rotate 3", do: assert KnotHash.rotate([1,2,3,4,5,6], 1, 4) == [1,5,4,3,2,6]
  test "rotate 4", do: assert KnotHash.rotate([1,2,3,4,5,6], 2, 4) == [1,2,6,5,4,3]
  test "rotate 5", do: assert KnotHash.rotate([1,2,3,4,5,6], 3, 4) == [4,2,3,1,6,5]
end

KnotHash.hashsum("106,16,254,226,55,2,1,166,177,247,93,0,255,228,60,36") |> IO.inspect
