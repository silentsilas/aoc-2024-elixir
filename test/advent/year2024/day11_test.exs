defmodule Advent.Year2024.Day11Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day11

  @example_input "125 17\n"

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = @example_input
      result = part1(input)

      assert result == 55_312
    end

    test "solves part1 with fixture data" do
      input = File.read!("test/fixtures/day11p1_input.txt")
      result = part1(input)

      assert result == 187_738
    end

    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day11p1_input.txt")
      result = part2(input)

      assert result == 223_767_210_249_237
    end
  end

  describe "zero_rule/1" do
    test "returns 1 when number is 0" do
      assert zero_rule(0) == 1
    end

    test "returns the number when it is not 0" do
      assert zero_rule(1) == 1
    end
  end

  describe "even_rule/1" do
    test "returns the digits split in half when it is even" do
      assert even_rule(1234, 1234) == {:ok, {12, 34}}
    end

    test "returns not_applicable when the number is odd" do
      assert even_rule(123, 123) == {:not_applicable, 123}
    end

    test "returns not_applicable if number is not equal to original number" do
      assert even_rule(1234, 123) == {:not_applicable, 1234}
    end
  end

  describe "multiply_rule/1" do
    test "multiplies the number by 2024" do
      assert multiply_rule(1, 1) == 2024
    end

    test "returns the number when it is not equal to the original number" do
      assert multiply_rule(1, 2) == 1
    end
  end

  describe "run_rules_with_frequencies/1" do
    test "applies zero_rule and even_rule to each number" do
      assert run_rules_with_frequencies([{125, 1}, {17, 1}]) == %{1 => 1, 7 => 1, 253_000 => 1}
    end
  end
end
