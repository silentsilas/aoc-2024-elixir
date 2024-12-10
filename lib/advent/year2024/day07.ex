defmodule Advent.Year2024.Day07 do
  @type operator :: :add | :multiply
  @type equation :: %{result: non_neg_integer(), values: [non_neg_integer()]}
  @type final_equation :: %{
          result: non_neg_integer(),
          values: [non_neg_integer()],
          operators: [operator()]
        }
  @type answer :: %{sum: non_neg_integer(), equations: [final_equation()]}

  @spec part1(String.t()) :: answer()
  def part1(input) do
    equations =
      input
      |> parse_equations()
      |> Enum.map(&solve_equation(&1, [:add, :multiply]))

    sum =
      equations
      |> Enum.reduce(0, fn equation, acc ->
        if length(equation.operators) > 0 do
          acc + equation.result
        else
          acc
        end
      end)

    %{
      sum: sum,
      equations: equations
    }
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

  @spec solve_equation(equation(), [operator()]) :: final_equation()
  def solve_equation(equation, allowed_operators) do
    %{result: target, values: values} = equation

    operators =
      case values do
        [single] when single == target -> []
        [value | rest] -> find_operators(rest, value, target, [], allowed_operators)
      end

    Map.put(equation, :operators, operators)
  end

  defp find_operators([], current, target, acc, _allowed_operators),
    do: if(current == target, do: acc, else: [])

  defp find_operators([value | rest], current, target, acc, allowed_operators) do
    operations = [
      {:add, fn -> current + value end},
      {:multiply, fn -> current * value end},
      {:concatenate, fn -> String.to_integer("#{current}#{value}") end}
    ]

    operations
    |> Enum.filter(fn {op, _} -> op in allowed_operators end)
    |> Enum.map(fn {op, calc} ->
      find_operators(rest, calc.(), target, acc ++ [op], allowed_operators)
    end)
    |> Enum.find([], &(&1 != []))
  end

  @spec part2(String.t()) :: answer()
  def part2(input) do
    %{sum: previous_sum, equations: equations} =
      input
      |> part1()

    unsolved_equations = Enum.filter(equations, &(&1.operators == []))

    equations =
      unsolved_equations
      |> Enum.map(&solve_equation(&1, [:add, :multiply, :concatenate]))

    sum =
      equations
      |> Enum.reduce(0, fn equation, acc ->
        if equation.operators != [] do
          acc + equation.result
        else
          acc
        end
      end)

    %{
      sum: previous_sum + sum,
      equations: equations
    }
  end
end
