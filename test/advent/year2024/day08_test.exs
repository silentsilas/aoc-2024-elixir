defmodule Advent.Year2024.Day08Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day08

  @part1_example_input "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"

  test "part1 example data" do
    input = @part1_example_input
    result = part1(input)

    assert result == 14
  end

  test "part1 fixture data" do
    input = File.read!("test/fixtures/day08p1_input.txt")
    result = part1(input)

    assert result == 423
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
