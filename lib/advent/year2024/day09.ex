defmodule Advent.Year2024.Day09 do
  @type block_id :: non_neg_integer()
  @type file_id :: non_neg_integer()
  @type disk_block :: {block_id(), file_id() | :free}
  @type disk_state :: [disk_block()]
  @type input_digits :: [non_neg_integer()]

  @spec part1(String.t()) :: non_neg_integer()
  def part1(input) do
    digits = parse(input)
    initial_disk_state = build_initial_disk(digits)
    disk_state = Enum.reverse(initial_disk_state)

    movable_files =
      Enum.filter(initial_disk_state, fn {_, content} -> content != :free end)

    final_disk_state = compress_disk(disk_state, movable_files, [])

    calculate_hash(final_disk_state)
  end

  @spec parse(String.t()) :: input_digits()
  def parse(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  @spec build_initial_disk(input_digits()) :: disk_state()
  defp build_initial_disk(digits) do
    build_initial_disk(digits, :file, _block_id = 0, _current_file = 0, _acc = [])
  end

  @spec build_initial_disk(input_digits(), :file | :free, block_id(), file_id(), disk_state()) ::
          disk_state()
  defp build_initial_disk([0 | remaining], :file, block_id, current_file, acc) do
    build_initial_disk(remaining, :free, block_id, current_file + 1, acc)
  end

  @spec build_initial_disk(input_digits(), :file | :free, block_id(), file_id(), disk_state()) ::
          disk_state()
  defp build_initial_disk([0 | remaining], :free, block_id, current_file, acc) do
    build_initial_disk(remaining, :file, block_id, current_file, acc)
  end

  @spec build_initial_disk(input_digits(), :file | :free, block_id(), file_id(), disk_state()) ::
          disk_state()
  defp build_initial_disk([count | remaining], :file, block_id, current_file, acc) do
    build_initial_disk(
      [count - 1 | remaining],
      :file,
      block_id + 1,
      current_file,
      [{block_id, current_file} | acc]
    )
  end

  @spec build_initial_disk(input_digits(), :file | :free, block_id(), file_id(), disk_state()) ::
          disk_state()
  defp build_initial_disk([count | remaining], :free, block_id, current_file, acc) do
    build_initial_disk(
      [count - 1 | remaining],
      :free,
      block_id + 1,
      current_file,
      [{block_id, :free} | acc]
    )
  end

  @spec build_initial_disk([], :file | :free, block_id(), file_id(), disk_state()) :: disk_state()
  defp build_initial_disk([], _state, _block_id, _current_file, acc), do: acc

  @spec compress_disk(disk_state(), disk_state(), disk_state()) :: disk_state()
  defp compress_disk(
         [{block_id, :free} | blocks],
         [{file_block_id, file_id} | movable_files],
         acc
       )
       when block_id <= file_block_id do
    compress_disk(blocks, movable_files, [{block_id, file_id} | acc])
  end

  defp compress_disk(
         [{block_id, file_id} | blocks],
         [{file_block_id, _} | _] = movable_files,
         acc
       )
       when block_id <= file_block_id do
    compress_disk(blocks, movable_files, [{block_id, file_id} | acc])
  end

  defp compress_disk(_blocks, _movable_files, acc), do: acc

  @spec calculate_hash(disk_state()) :: non_neg_integer()
  defp calculate_hash(disk_state) do
    Enum.reduce(disk_state, 0, fn
      {block_id, file_id}, acc when is_integer(file_id) -> acc + block_id * file_id
      {_block_id, :free}, acc -> acc
    end)
  end

  def part2(_) do
    :not_implemented
  end
end
