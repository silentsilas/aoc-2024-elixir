defmodule Advent.Year2024.Day06Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day06

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
      result = part1(input)

      assert result == 41
    end

    test "solves part 1 with fixture data" do
      input = File.read!("test/fixtures/day06p1_input.txt")
      result = part1(input)

      assert result == 5030
    end

    test "solves part 2 with example data" do
      input = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
      result = part2(input)

      assert result == 6
    end

    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day06p1_input.txt")
      result = part2(input)

      assert result == 1928
    end
  end
end
