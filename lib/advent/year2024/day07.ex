defmodule Advent.Year2024.Day07 do
  @type operator :: :add | :multiply
  @type equation :: %{result: non_neg_integer(), values: [non_neg_integer()]}
  @type final_equation :: %{
          result: non_neg_integer(),
          values: [non_neg_integer()],
          operators: [operator()]
        }

  def part1(input) do
    input
    |> parse_equations()
    |> Enum.map(&solve_equation/1)
    |> Enum.reduce(0, fn equation, acc ->
      if length(equation.operators) > 0 do
        acc + equation.result
      else
        acc
      end
    end)
  end

  @spec parse_equations(String.t()) :: [equation()]
  def parse_equations(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [result, values] ->
      values = String.split(values, " ", trim: true)

      %{
        result: String.to_integer(result),
        values: values |> Enum.map(&String.to_integer(&1))
      }
    end)
  end

  @spec solve_equation(equation()) :: [operator()]
  def solve_equation(equation) do
    %{result: target, values: values} = equation

    operators =
      case values do
        [single] when single == target -> []
        [value | rest] -> find_operators(rest, value, target, [])
      end

    Map.put(equation, :operators, operators)
  end

  defp find_operators([], current, target, acc), do: if(current == target, do: acc, else: [])

  defp find_operators([value | rest], current, target, acc) do
    add_result = find_operators(rest, current + value, target, acc ++ [:add])
    mult_result = find_operators(rest, current * value, target, acc ++ [:multiply])

    # Return first non-empty result
    case {add_result, mult_result} do
      {[], []} -> []
      {[], result} -> result
      {result, _} -> result
    end
  end

  def part2(args) do
    args
  end
end
