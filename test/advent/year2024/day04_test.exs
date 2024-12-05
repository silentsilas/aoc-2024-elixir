defmodule Advent.Year2024.Day04Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day04

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

      result = part1(input)

      assert result == 18
    end

    test "solves part 1 with fixture data" do
      input = File.read!("test/fixtures/day04p1_input.txt")
      result = part1(input)

      assert result == 2468
    end
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
