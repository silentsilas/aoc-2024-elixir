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

    test "solves part 2 with example data" do
      input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
      result = part2(input)

      assert result == 48
    end

    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day03p1_input.txt")
      result = part2(input)

      assert result == 111_762_583
    end
  end

  describe "find_multiplications/1" do
    test "finds multiplication instructions with positions" do
      input = "mul(2,4)other_mul(3,5)"
      result = find_multiplications(input)

      assert result == [{0, {:mul, 8}}, {14, {:mul, 15}}]
    end
  end

  describe "find_dos/1" do
    test "finds do instructions with positions" do
      input = "something_do()_other_do()"
      result = find_dos(input)

      assert result == [{10, {:do, true}}, {21, {:do, true}}]
    end
  end

  describe "find_donts/1" do
    test "finds don't instructions with positions" do
      input = "something_don't()_other_don't()"
      result = find_donts(input)

      assert result == [{10, {:do, false}}, {24, {:do, false}}]
    end
  end

  describe "process_instructions/1" do
    test "processes instructions in order and returns sum" do
      instructions = [
        # enabled = true, sum = 8
        {0, {:mul, 8}},
        # enabled = false, sum = 8
        {5, {:do, false}},
        # enabled = false, sum = 8
        {10, {:mul, 15}},
        # enabled = true, sum = 8
        {15, {:do, true}},
        # enabled = true, sum = 18
        {20, {:mul, 10}}
      ]

      result = process_instructions(instructions)

      assert result == 18
    end
  end
end
