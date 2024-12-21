defmodule Advent.Year2024.Day10Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day10

  @example_input """
  89010123
  78121874
  87430965
  96549874
  45678903
  32019012
  01329801
  10456732
  """

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = @example_input
      result = part1(input)

      assert result == 36
    end

    test "solves part1 with fixture data" do
      input = File.read!("test/fixtures/day10p1_input.txt")
      result = part1(input)

      assert result == 468
    end

    test "solves part 2 with example data" do
      input = @example_input
      result = part2(input)

      assert result == 81
    end

    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day10p1_input.txt")
      result = part2(input)

      assert result == 966
    end
  end
end
