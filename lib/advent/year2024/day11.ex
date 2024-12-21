defmodule Advent.Year2024.Day11 do
  @type number_counts :: %{integer() => non_neg_integer()}

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

  @spec parse(String.t()) :: [integer()]
  defp parse(input) do
    input
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @spec solve([integer()], non_neg_integer()) :: integer()
  defp solve(initial_arrangement, iterations) do
    initial_counts = Enum.frequencies(initial_arrangement)

    1..iterations
    |> Enum.reduce(initial_counts, fn _, acc -> run_rules_with_frequencies(acc) end)
    |> Map.values()
    |> Enum.sum()
  end

  @spec run_rules_with_frequencies(number_counts()) :: number_counts()
  def run_rules_with_frequencies(number_counts) do
    Enum.reduce(number_counts, %{}, fn {number, count}, result_counts ->
      number
      |> process_single_number()
      |> Enum.reduce(result_counts, fn new_number, updated_counts ->
        Map.update(updated_counts, new_number, count, &(&1 + count))
      end)
    end)
  end

  @spec process_single_number(integer()) :: [integer()]
  def process_single_number(number) do
    number
    |> zero_rule()
    |> then(fn after_zero ->
      case even_rule(after_zero, number) do
        {:ok, {left, right}} -> [left, right]
        {:not_applicable, n} -> [multiply_rule(n, number)]
      end
    end)
  end

  @spec zero_rule(integer()) :: integer()
  def zero_rule(0), do: 1
  def zero_rule(number), do: number

  @spec even_rule(integer(), integer()) ::
          {:ok, {integer(), integer()}} | {:not_applicable, integer()}
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

  @spec multiply_rule(integer(), integer()) :: integer()
  def multiply_rule(number, original) when number == original, do: number * 2024
  def multiply_rule(number, _original), do: number
end
