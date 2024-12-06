defmodule Advent.Year2024.Day05 do
  @type rule :: %{leading: integer(), trailing: integer()}
  @type ordering :: [integer()]

  @spec part1(String.t()) :: integer()
  def part1(input) do
    [rules, ordering] = String.split(input, "\n\n")

    rules = parse_rules(rules)
    ordering = parse_ordering(ordering)

    %{valid: valid_ordering} = valid_orderings(rules, ordering)
    sum_middle_values(valid_ordering)
  end

  @spec part2(String.t()) :: integer()
  def part2(input) do
    [rules, ordering] = String.split(input, "\n\n")

    rules = parse_rules(rules)
    ordering = parse_ordering(ordering)

    %{invalid: invalid_orderings} = valid_orderings(rules, ordering)

    invalid_orderings
    |> fix_orderings(rules)
    |> sum_middle_values()
  end

  @spec parse_rules(String.t()) :: rule()
  def parse_rules(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.map(fn rule ->
      [leading, trailing] = rule
      %{leading: String.to_integer(leading), trailing: String.to_integer(trailing)}
    end)
  end

  @spec parse_ordering(String.t()) :: ordering()
  def parse_ordering(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(fn line ->
      line
      |> Enum.map(fn num -> String.to_integer(num) end)
    end)
  end

  @spec valid_orderings([rule()], [ordering()]) :: %{valid: [ordering()], invalid: [ordering()]}
  def valid_orderings(rules, orderings) do
    Enum.reduce(orderings, %{valid: [], invalid: []}, fn ordering, acc ->
      if valid_ordering?(rules, ordering) do
        %{acc | valid: [ordering | acc.valid]}
      else
        %{acc | invalid: [ordering | acc.invalid]}
      end
    end)
  end

  @spec valid_ordering?([rule()], ordering()) :: boolean()
  defp valid_ordering?(rules, ordering) do
    Enum.all?(rules, fn rule -> passes_rule?(rule, ordering) end)
  end

  @spec passes_rule?(rule(), ordering()) :: boolean()
  defp passes_rule?(%{leading: leading, trailing: trailing}, ordering) do
    case {Enum.find_index(ordering, &(&1 == leading)),
          Enum.find_index(ordering, &(&1 == trailing))} do
      {nil, _} -> true
      {_, nil} -> true
      {lead_idx, trail_idx} -> lead_idx < trail_idx
    end
  end

  @spec sum_middle_values([ordering()]) :: integer()
  def sum_middle_values(orderings) do
    orderings
    |> Enum.map(&get_middle_value/1)
    |> Enum.sum()
  end

  @spec get_middle_value(ordering()) :: integer()
  defp get_middle_value(ordering) do
    middle_index = div(length(ordering), 2)
    Enum.at(ordering, middle_index)
  end

  @spec fix_orderings([ordering()], [rule()]) :: [ordering()]
  def fix_orderings(orderings, rules) do
    Enum.map(orderings, fn ordering -> fix_all_rules(ordering, rules) end)
  end

  @spec fix_ordering(ordering(), rule()) :: ordering()
  def fix_ordering(ordering, %{leading: leading, trailing: trailing}) do
    case {Enum.find_index(ordering, &(&1 == leading)),
          Enum.find_index(ordering, &(&1 == trailing))} do
      {nil, _} ->
        ordering

      {_, nil} ->
        ordering

      {lead_idx, trail_idx} when lead_idx < trail_idx ->
        ordering

      {lead_idx, trail_idx} ->
        List.delete_at(ordering, max(lead_idx, trail_idx))
        |> List.delete_at(min(lead_idx, trail_idx))
        |> List.insert_at(min(lead_idx, trail_idx), leading)
        |> List.insert_at(min(lead_idx, trail_idx) + 1, trailing)
    end
  end

  @spec fix_all_rules(ordering(), [rule()]) :: ordering()
  def fix_all_rules(ordering, rules) do
    # Keep applying rules until no changes are made
    fixed = Enum.reduce(rules, ordering, &fix_ordering(&2, &1))

    if fixed == ordering do
      fixed
    else
      fix_all_rules(fixed, rules)
    end
  end
end
