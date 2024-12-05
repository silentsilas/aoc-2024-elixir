defmodule Advent.Year2024.Day02Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day02

  describe "to_rows/1" do
    test "parses input" do
      input = "7 6 4 2 1\n1 2 7 8 9\n9 7 6 2 1\n1 3 2 4 5\n8 6 4 4 1\n1 3 6 7 9"

      expected = [
        [7, 6, 4, 2, 1],
        [1, 2, 7, 8, 9],
        [9, 7, 6, 2, 1],
        [1, 3, 2, 4, 5],
        [8, 6, 4, 4, 1],
        [1, 3, 6, 7, 9]
      ]

      assert to_rows(input) == expected
    end
  end

  describe "row_increases_or_decreases_safely/1" do
    test "returns true if row increases or decreases by at most 3" do
      assert row_increases_or_decreases_safely([1, 0, 1, 2, 3])
      refute row_increases_or_decreases_safely([1, 2, 3, 4, 8])
    end
  end

  describe "row_only_increases_or_decreases" do
    test "returns true if row only increases or decreases" do
      assert row_only_increases_or_decreases([1, 2, 3, 4, 5])
      assert row_only_increases_or_decreases([5, 4, 3, 2, 1])
      refute row_only_increases_or_decreases([1, 2, 3, 4, 3])
    end
  end

  describe "part1/1" do
    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day02p1_input.txt")
      result = part1(input)

      assert result == 631
    end
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
