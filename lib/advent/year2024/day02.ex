defmodule Advent.Year2024.Day02 do
  @moduledoc """
  Solution for Advent of Code 2024, Day 2.
  """

  @type row :: [integer()]

  @spec part1(String.t()) :: non_neg_integer()
  def part1(args) do
    args
    |> to_rows()
    |> Enum.count(&row_is_safe?(&1, 0))
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(args) do
    args
    |> to_rows()
    |> Enum.count(&row_is_safe?(&1, 1))
  end

  @spec row_is_safe?(row(), integer()) :: boolean()
  def row_is_safe?(_row, threshold) when threshold < 0, do: false

  def row_is_safe?(row, threshold) do
    if row_is_valid?(row) do
      true
    else
      Enum.with_index(row)
      |> Enum.any?(fn {_val, idx} ->
        row
        |> List.delete_at(idx)
        |> row_is_safe?(threshold - 1)
      end)
    end
  end

  @spec row_is_valid?(row()) :: boolean()
  def row_is_valid?(row) do
    row_increases_or_decreases_safely?(row) and row_only_increases_or_decreases?(row)
  end

  @spec row_increases_or_decreases_safely?(row()) :: boolean()
  def row_increases_or_decreases_safely?(row) do
    row
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> abs(a - b) <= 3 end)
  end

  @spec row_only_increases_or_decreases?(row()) :: boolean()
  def row_only_increases_or_decreases?(row) do
    strictly_increasing?(row) or strictly_decreasing?(row)
  end

  @spec strictly_increasing?(row()) :: boolean()
  def strictly_increasing?(row) do
    row
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a < b end)
  end

  @spec strictly_decreasing?(row()) :: boolean()
  def strictly_decreasing?(row) do
    row
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a > b end)
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
end
