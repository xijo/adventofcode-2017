defmodule KnotHash do
  def checksum(list, vector) do
    [a, b | _] = rotate_by(list, vector)
    a * b
  end

  def rotate_by(list, vector) do
    vector = zip_skips(vector)
    Enum.reduce(vector, list, fn({size, position}, list) -> rotate(list, position, size) end)
  end

  def zip_skips(list) do
    do_zip_skips(Enum.with_index(list), 0, length(list))
  end

  def do_zip_skips([{value, _}], current_position, _) do
    [{value, current_position}]
  end

  def do_zip_skips([{value, index} | tail], current_position, length) do
    [{value, current_position} | do_zip_skips(tail, current_position + value + index, length)]
  end

  def rotate(list, position, size) do
    window = sublist(list, position, size) |> Enum.reverse
    replace_sublist(list, position, window)
  end

  def replace_sublist(list, _, []) do
    list
  end

  def replace_sublist(list, index, [head | tail]) do
    list = replace_at(list, index, head)
    replace_sublist(list, index + 1, tail)
  end

  def replace_at(list, index, value) do
    index = rem(index, length(list))
    List.replace_at(list, index, value)
  end

  def sublist(list, 0, size) do
    Enum.take(list, size)
  end

  def sublist([head | tail], offset, size) do
    sublist(tail ++ [head], offset - 1, size)
  end
end

ExUnit.start
ExUnit.configure trace: true

defmodule KnotHashTest do
  use ExUnit.Case

  test "sublist 1", do: assert KnotHash.sublist([0, 1, 2, 3, 4], 0, 3) == [0, 1, 2]
  test "sublist 2", do: assert KnotHash.sublist([0, 1, 2, 3, 4], 1, 3) == [1, 2, 3]
  test "sublist 3", do: assert KnotHash.sublist([0, 1, 2, 3, 4], 3, 3) == [3, 4, 0]

  test "replace_at 1", do: assert KnotHash.replace_at([0, 1, 2], 0, 9) == [9, 1, 2]
  test "replace_at 2", do: assert KnotHash.replace_at([0, 1, 2], 1, 9) == [0, 9, 2]
  test "replace_at 3", do: assert KnotHash.replace_at([0, 1, 2], 2, 9) == [0, 1, 9]
  test "replace_at 4", do: assert KnotHash.replace_at([0, 1, 2], 3, 9) == [9, 1, 2]

  test "replace_sublist 1", do: assert KnotHash.replace_sublist([0, 1, 2, 3], 1, [9, 9]) == [0, 9, 9, 3]
  test "replace_sublist 2", do: assert KnotHash.replace_sublist([0, 1, 2, 3], 3, [9, 9]) == [9, 1, 2, 9]

  test "zip_skips 1", do: assert KnotHash.zip_skips([3, 4, 1, 5]) == [{3,0}, {4,3}, {1,8}, {5,11}]

  test "rotation 1" do
    assert KnotHash.rotate([0, 1, 2, 3, 4], 0, 3) == [2, 1, 0, 3, 4]
  end

  test "rotate_by 1" do
    assert KnotHash.rotate_by([0, 1, 2, 3, 4], [3, 4, 1, 5]) == [3, 4, 2, 1, 0]
  end

  test "checksum 1", do: assert KnotHash.checksum([0, 1, 2, 3, 4], [3, 4, 1, 5]) == 12
end

# Input for xijo
vector = [106, 16, 254, 226, 55, 2, 1, 166, 177, 247, 93, 0, 255, 228, 60, 36]
list   = 0..255 |> Enum.to_list

KnotHash.checksum(list, vector) |> IO.inspect
