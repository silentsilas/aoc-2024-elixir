defmodule Advent.Year2024.Day01Test do
  use ExUnit.Case
  doctest Advent.Year2024.Day01

  alias Advent.Year2024.Day01

  describe "part1/1" do
    test "solves part 1 with fixture data" do
      input = File.read!("test/fixtures/day01p1_input.txt")
      result = Day01.part1(input)

      assert result == 1_110_981
    end
  end

  describe "to_columns/1" do
    test "converts input string into column pairs" do
      input = "5 3\n2 7\n8 1"
      expected = [{5, 3}, {2, 7}, {8, 1}]

      assert Day01.to_columns(input) == expected
    end
  end

  describe "sort_columns/1" do
    test "sorts both columns independently" do
      input = [{5, 3}, {2, 7}, {8, 1}]
      expected = [{2, 1}, {5, 3}, {8, 7}]

      assert Day01.sort_columns(input) == expected
    end

    test "handles duplicate values" do
      input = [{5, 3}, {5, 3}, {2, 3}]
      expected = [{2, 3}, {5, 3}, {5, 3}]

      assert Day01.sort_columns(input) == expected
    end
  end

  describe "distance_between_columns/1" do
    test "calculates absolute differences between columns" do
      input = [{5, 3}, {2, 7}, {8, 1}]
      expected = 14

      assert Day01.distance_between_columns(input) == expected
    end
  end

  describe "part2/1" do
    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day01p1_input.txt")
      result = Day01.part2(input)

      assert result == 24_869_388
    end
  end

  describe "calculate_similary_score/1" do
    test "calculates the similarity score" do
      input = [{3, 4}, {4, 3}, {2, 5}, {1, 3}, {3, 9}, {3, 3}]
      expected = 31

      assert Day01.calculate_similary_score(input) == expected
    end
  end
end
