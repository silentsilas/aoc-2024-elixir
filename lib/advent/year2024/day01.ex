defmodule Advent.Year2024.Day01 do
  @moduledoc """
  Solution for Advent of Code 2024, Day 1.
  """

  @type column_pair :: {integer(), integer()}
  @type column_pairs :: [column_pair()]

  @doc """
  Solves part 1 of the puzzle.
  Takes raw input string and returns the distance between sorted columns.
  """
  @spec part1(String.t()) :: integer()
  def part1(args) do
    args
    |> to_columns()
    |> sort_columns()
    |> distance_between_columns()
  end

  @doc """
  Solves part 2 of the puzzle.
  Takes raw input string and returns the similarity score between columns.
  """
  @spec part2(String.t()) :: term()
  def part2(args) do
    args
    |> to_columns()
    |> calculate_similary_score()
  end

  @spec to_columns(String.t()) :: column_pairs()
  def to_columns(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [col1, col2] = String.split(line, ~r/\s+/, trim: true)
      {String.to_integer(col1), String.to_integer(col2)}
    end)
  end

  @spec sort_columns(column_pairs()) :: column_pairs()
  def sort_columns(data) do
    {col1, col2} = Enum.unzip(data)
    Enum.zip(Enum.sort(col1), Enum.sort(col2))
  end

  @spec distance_between_columns(column_pairs()) :: integer()
  def distance_between_columns(data) do
    Enum.map(data, fn {col1, col2} -> abs(col1 - col2) end)
    |> Enum.reduce(fn dist, acc -> dist + acc end)
  end

  @spec calculate_similary_score(column_pairs()) :: integer()
  def calculate_similary_score(data) do
    {first_column, second_column} = Enum.unzip(data)

    # multiply first column number by how many times it exists in the second column
    Enum.map(first_column, fn num -> num * Enum.count(second_column, &(&1 == num)) end)
    |> Enum.reduce(fn score, acc -> score + acc end)
  end
end
