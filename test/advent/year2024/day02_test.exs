defmodule Advent.Year2024.Day02Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day02

  describe "part1/1" do
    test "solves part 1 with fixture data" do
      input = File.read!("test/fixtures/day02p1_input.txt")
      result = part1(input)

      assert result == 631
    end
  end

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

  describe "strictly_increasing?/1" do
    test "identifies strictly increasing sequences" do
      assert strictly_increasing?([1, 2, 3, 4, 5])
      assert strictly_increasing?([1, 3, 4])
      refute strictly_increasing?([1, 2, 2, 3])
      refute strictly_increasing?([5, 4, 3, 2, 1])
    end
  end

  describe "strictly_decreasing?/1" do
    test "identifies strictly decreasing sequences" do
      assert strictly_decreasing?([5, 4, 3, 2, 1])
      assert strictly_decreasing?([3, 2, 1])
      refute strictly_decreasing?([3, 2, 2, 1])
      refute strictly_decreasing?([1, 2, 3, 4, 5])
    end
  end

  describe "row_increases_or_decreases_safely?/1" do
    test "checks if adjacent differences are at most 3" do
      assert row_increases_or_decreases_safely?([1, 2, 3, 4, 5])
      assert row_increases_or_decreases_safely?([5, 4, 3, 2, 1])
      assert row_increases_or_decreases_safely?([1, 3, 4, 6, 7])
      refute row_increases_or_decreases_safely?([1, 5, 8, 12, 15])
    end
  end

  describe "row_only_increases_or_decreases?/1" do
    test "checks if sequence is monotonic" do
      assert row_only_increases_or_decreases?([1, 2, 3, 4, 5])
      assert row_only_increases_or_decreases?([5, 4, 3, 2, 1])
      refute row_only_increases_or_decreases?([1, 3, 2, 4, 5])
      refute row_only_increases_or_decreases?([5, 3, 4, 2, 1])
    end
  end

  describe "row_is_valid?/1" do
    test "combines safety checks" do
      # Increasing and safe steps
      assert row_is_valid?([1, 2, 3, 4, 5])
      # Decreasing and safe steps
      assert row_is_valid?([5, 4, 3, 2, 1])
      # Safe steps but not monotonic
      refute row_is_valid?([1, 4, 3, 5])
      # Monotonic but unsafe step
      refute row_is_valid?([1, 2, 6, 7])
    end
  end

  describe "row_is_safe?/2" do
    test "handles different thresholds" do
      # No removals allowed
      assert row_is_safe?([1, 2, 3, 4, 5], 0)
      refute row_is_safe?([1, 3, 2, 4, 5], 0)

      # One removal allowed
      # Remove 3
      assert row_is_safe?([1, 3, 2, 4, 5], 1)
      # Remove 5
      assert row_is_safe?([1, 2, 5, 3, 4], 1)
      # Can't fix with one removal
      refute row_is_safe?([1, 5, 2, 6, 3], 1)
    end
  end

  describe "part2/1" do
    test "solves part 2 with example data" do
      input = "7 6 4 2 1\n1 2 7 8 9\n9 7 6 2 1\n1 3 2 4 5\n8 6 4 4 1\n1 3 6 7 9"
      result = part2(input)

      assert result == 4
    end

    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day02p1_input.txt")
      result = part2(input)

      assert result == 665
    end
  end
end
