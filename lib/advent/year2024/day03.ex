defmodule Advent.Year2024.Day03 do
  @type instruction() :: {integer(), {:do, boolean()} | {:mul, integer()}}
  def part1(args) do
    args
    |> find_multiplications()
    |> process_instructions()
  end

  def part2(args) do
    args
    |> find_all_instructions()
    |> Enum.sort()
    |> process_instructions()
  end

  @spec find_all_instructions(String.t()) :: [instruction()]
  def find_all_instructions(input) do
    muls = find_multiplications(input)
    dos = find_dos(input)
    donts = find_donts(input)
    muls ++ dos ++ donts
  end

  @spec find_multiplications(String.t()) :: [instruction()]
  def find_multiplications(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input, return: :index)
    |> Enum.map(fn [{pos, _len} | nums] ->
      [num1, num2] =
        Enum.map(nums, fn {pos, len} ->
          String.to_integer(String.slice(input, pos, len))
        end)

      {pos, {:mul, num1 * num2}}
    end)
  end

  @spec find_dos(String.t()) :: [instruction()]
  def find_dos(input) do
    Regex.scan(~r/do\(\)/, input, return: :index)
    |> Enum.map(fn [{pos, _len}] -> {pos, {:do, true}} end)
  end

  @spec find_donts(String.t()) :: [instruction()]
  def find_donts(input) do
    Regex.scan(~r/don't\(\)/, input, return: :index)
    |> Enum.map(fn [{pos, _len}] -> {pos, {:do, false}} end)
  end

  @spec process_instructions([instruction()]) :: integer()
  def process_instructions(instructions) do
    {_pos, {_enabled, sum}} =
      Enum.reduce(instructions, {0, {true, 0}}, fn
        {pos, {:do, enabled}}, {_last_pos, {_enabled, sum}} ->
          {pos, {enabled, sum}}

        {pos, {:mul, result}}, {_last_pos, {enabled, sum}} ->
          {pos, {enabled, sum + if(enabled, do: result, else: 0)}}
      end)

    sum
  end
end
