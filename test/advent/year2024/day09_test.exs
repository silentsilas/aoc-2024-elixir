defmodule Advent.Year2024.Day09Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day09

  @part1_example_input "2333133121414131402"

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = @part1_example_input
      result = part1(input)

      assert result == 1928
    end

    test "solves part1 with fixture data" do
      input = File.read!("test/fixtures/day09p1_input.txt")
      result = part1(input)

      assert result == 0
    end
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
