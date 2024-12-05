defmodule Advent.Year2024.Day03Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day03

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
      result = part1(input)

      assert result == 161
    end

    test "solves part 1 with fixture data" do
      input = File.read!("test/fixtures/day03p1_input.txt")
      result = part1(input)

      assert result == 169_021_493
    end
  end

  test "solves part 2 with example data" do
    input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    result = part2(input)

    assert result == 48
  end

  test "solves part 2 with fixture data" do
    input = File.read!("test/fixtures/day03p1_input.txt")
    result = part2(input)

    assert result == 0
  end
end
