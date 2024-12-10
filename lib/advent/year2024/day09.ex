defmodule Advent.Year2024.Day09 do
  def part1(input) do
    input
    |> parse_input()
    |> expand_to_disk_map()
    |> compact_disk()
    |> hashsum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.graphemes/1)
    |> Enum.map(&String.to_integer/1)
  end

  # expands "2333133121414131402" to "00...111...2...333.44.5555.6666.777.888899"
  defp expand_to_disk_map(numbers) do
    numbers
    |> Enum.with_index()
    |> Enum.reduce_while({0, ""}, &expand_segment/2)
    |> elem(1)
    |> String.graphemes()
  end

  defp expand_segment({block, index}, {current_id, acc}) do
    if Integer.mod(index, 2) == 0 do
      # File block
      {:cont, {current_id + 1, acc <> String.duplicate(Integer.to_string(current_id), block)}}
    else
      # Space block
      {:cont, {current_id, acc <> String.duplicate(".", block)}}
    end
  end

  defp compact_disk(initial_disk) do
    initial_disk
    |> Stream.iterate(&move_next_file/1)
    |> Stream.take_while(&(&1 != nil))
    |> Stream.map(&Enum.join/1)
    |> Enum.to_list()
    |> List.last()
  end >
    defp move_next_file(disk) do
      with {:ok, dot_index} <- find_leftmost_dot(disk),
           {:ok, file_index} <- find_rightmost_file(disk, dot_index) do
        move_file(disk, file_index, dot_index)
      else
        _ -> nil
      end
    end

  defp find_leftmost_dot(disk) do
    case Enum.find_index(disk, &(&1 == ".")) do
      nil -> :error
      index -> {:ok, index}
    end
  end

  defp find_rightmost_file(disk, after_index) do
    disk
    |> Enum.drop(after_index + 1)
    |> Enum.with_index(after_index + 1)
    |> Enum.reverse()
    |> Enum.find(fn {char, _i} -> char != "." end)
    |> case do
      nil -> :error
      {_char, index} -> {:ok, index}
    end
  end

  defp move_file(disk, from_index, to_index) do
    {before_from, [file | after_from]} = Enum.split(disk, from_index)
    {before_to, [_dot | after_to]} = Enum.split(before_from, to_index)

    before_to ++ [file] ++ after_to ++ ["."] ++ after_from
  end

  defp hashsum(disk) do
    disk
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {char, index}, acc ->
      if char == "." do
        acc
      else
        acc + index * String.to_integer(char)
      end
    end)
  end

  def part2(_input) do
    :ok
  end
end
