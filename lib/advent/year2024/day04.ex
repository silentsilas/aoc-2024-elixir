defmodule Advent.Year2024.Day04 do
  @moduledoc """
  Solution for Advent of Code 2024, Day 4.
  """

  @target "XMAS"
  @directions [
    # right
    {0, 1},
    # down
    {1, 0},
    # diagonal down-right
    {1, 1},
    # diagonal down-left
    {1, -1},
    # left
    {0, -1},
    # up
    {-1, 0},
    # diagonal up-right
    {-1, 1},
    # diagonal up-left
    {-1, -1}
  ]

  @type grid :: [[String.t()]]
  @type direction :: {integer, integer}

  def part1(args) do
    args
    |> count_target_word()
  end

  @spec count_target_word(String.t()) :: non_neg_integer
  def count_target_word(input) do
    # Convert input string to grid of characters
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    rows = length(grid)
    cols = length(hd(grid))

    # Count total occurrences
    # uses generators to iterate over all possible starting positions and directions
    for row <- 0..(rows - 1),
        col <- 0..(cols - 1),
        direction <- @directions,
        word = check_direction(grid, row, col, direction),
        word == @target do
      1
    end
    |> Enum.sum()
  end

  @spec check_direction(grid, integer, integer, direction) :: String.t()
  defp check_direction(grid, row, col, {dx, dy}) do
    0..(String.length(@target) - 1)
    |> Enum.reduce_while("", fn i, acc ->
      new_row = row + i * dx
      new_col = col + i * dy

      if valid_position?(new_row, new_col, length(grid), length(hd(grid))) do
        {:cont, acc <> Enum.at(Enum.at(grid, new_row), new_col)}
      else
        {:halt, ""}
      end
    end)
  end

  @spec valid_position?(integer, integer, integer, integer) :: boolean
  defp valid_position?(row, col, rows, cols) do
    row >= 0 and row < rows and col >= 0 and col < cols
  end

  def part2(args) do
    args
  end
end
