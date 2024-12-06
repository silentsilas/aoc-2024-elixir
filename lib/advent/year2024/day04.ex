defmodule Advent.Year2024.Day04 do
  @moduledoc """
  Solution for Advent of Code 2024, Day 4.
  """

  @type grid :: %{position => String.t()}
  @type position :: {integer, integer}
  @type direction :: {integer, integer}

  @spec part1(String.t()) :: integer
  def part1(input) do
    input
    |> to_grid()
    |> find_words("XMAS", [
      {0, 1},
      {1, 0},
      {1, 1},
      {1, -1},
      {0, -1},
      {-1, 0},
      {-1, 1},
      {-1, -1}
    ])
    |> Enum.count()
  end

  @spec to_grid(String.t()) :: grid()
  def to_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_idx}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, cell_idx}, acc ->
        Map.put(acc, {row_idx, cell_idx}, cell)
      end)
    end)
  end

  @spec find_words(grid(), String.t(), [direction()]) :: [{position, direction}]
  def find_words(grid, word \\ "XMAS", directions) do
    for {{row, col}, _} <- grid,
        direction <- directions,
        check_word(grid, {row, col}, word, direction) do
      {{row, col}, direction}
    end
  end

  @spec check_word(grid(), position(), String.t(), direction()) :: boolean
  defp check_word(grid, {row, col}, word, {row_step, col_step}) do
    word
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.all?(fn {char, idx} ->
      new_row = row + idx * row_step
      new_col = col + idx * col_step

      Map.get(grid, {new_row, new_col}) == char
    end)
  end

  @spec part2(String.t()) :: integer
  def part2(input) do
    to_grid(input)
    |> find_crosses()
  end

  @spec find_crosses(grid()) :: integer
  defp find_crosses(grid) do
    diagonal_pairs = [
      {{-1, 1}, {1, -1}},
      {{1, 1}, {-1, -1}}
    ]

    # Find all A characters
    a_positions = for {{row, col}, char} <- grid, char == "A", do: {row, col}

    # Check if there are MAS's in the diagonal pairs for each A
    a_positions
    |> Enum.reduce(0, fn {a_row, a_col}, final_sum ->
      total_mas =
        diagonal_pairs
        |> Enum.reduce(0, fn {{row_step, col_step}, {end_row_step, end_col_step}}, acc ->
          start_coordinate = {a_row + row_step, a_col + col_step}
          end_coordinate = {a_row + end_row_step, a_col + end_col_step}

          if mas_match?(grid, start_coordinate, end_coordinate), do: acc + 1, else: acc
        end)

      if total_mas >= 2 do
        final_sum + 1
      else
        final_sum
      end
    end)
  end

  @spec mas_match?(grid(), position(), position()) :: boolean
  defp mas_match?(grid, start_coordinate, end_coordinate) do
    (Map.get(grid, start_coordinate) == "M" and Map.get(grid, end_coordinate) == "S") or
      (Map.get(grid, start_coordinate) == "S" and Map.get(grid, end_coordinate) == "M")
  end
end
