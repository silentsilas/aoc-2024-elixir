defmodule Advent.Year2024.Day11 do
  def part1(input) do
    input
    |> parse()
    |> solve(25)
  end

  def part2(input) do
    input
    |> parse()
    |> solve(75)
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp solve(initial_arrangement, iterations) do
    Enum.reduce(1..iterations, initial_arrangement, fn _, acc ->
      run_rules(acc)
    end)
    |> length()
  end

  def run_rules(numbers) do
    numbers
    |> Enum.map(fn original_number ->
      after_zero = zero_rule(original_number)

      case even_rule(after_zero, original_number) do
        {:ok, {left, right}} -> [left, right]
        {:not_applicable, _} -> [multiply_rule(after_zero, original_number)]
      end
    end)
    |> List.flatten()
  end

  def zero_rule(0), do: 1
  def zero_rule(number), do: number

  def even_rule(number, original) when number >= 10 and number == original do
    digit_count = trunc(:math.log10(number)) + 1

    if rem(digit_count, 2) == 0 do
      # Calculate split point
      half_digits = div(digit_count, 2)
      power = trunc(:math.pow(10, half_digits))

      left = div(number, power)
      right = rem(number, power)

      {:ok, {left, right}}
    else
      {:not_applicable, number}
    end
  end

  def even_rule(number, _original), do: {:not_applicable, number}

  def multiply_rule(number, original) when number == original, do: number * 2024
  def multiply_rule(number, _original), do: number
end
