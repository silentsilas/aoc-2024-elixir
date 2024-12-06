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

    test "solves part 2 with example data" do
      input = ".M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
.........."

      result = part2(input)

      assert result == 9
    end

    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day04p1_input.txt")
      result = part2(input)

      assert result == 1864
    end
  end
end
