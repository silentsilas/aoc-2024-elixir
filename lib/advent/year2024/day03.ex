defmodule Advent.Year2024.Day03 do
  def part1(args) do
    ~r/mul\((\d+),(\d+)\)/
    |> Regex.scan(args)
    |> Enum.map(fn [_full_match, num1, num2] ->
      String.to_integer(num1) * String.to_integer(num2)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
  end
end
