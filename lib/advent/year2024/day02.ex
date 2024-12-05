defmodule Advent.Year2024.Day02 do
  @moduledoc """
  Solution for Advent of Code 2024, Day 2.
  """

  @type row :: [integer()]

  @doc """
  Solves part 1 of the puzzle.
  Takes raw input string and returns how many rows are deemed safe.
  """
  @spec part1(String.t()) :: integer()
  def part1(args) do
    args
    |> to_rows()
    |> Enum.reduce(0, fn row, acc ->
      if row_increases_or_decreases_safely(row) and row_only_increases_or_decreases(row) do
        acc + 1
      else
        acc
      end
    end)
  end

  def part2(args) do
    args
  end

  @spec to_rows(String.t()) :: [row()]
  def to_rows(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  # returns true if each element in row increases or decreases by at most 3
  @spec row_increases_or_decreases_safely(row()) :: boolean()
  def row_increases_or_decreases_safely(row) do
    row
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> abs(a - b) <= 3 end)
  end

  @spec row_only_increases_or_decreases(row()) :: boolean()
  def row_only_increases_or_decreases(row) do
    only_increases =
      row
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.all?(fn [a, b] -> a < b end)

    only_decreases =
      row
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.all?(fn [a, b] -> a > b end)

    only_increases or only_decreases
  end
end
