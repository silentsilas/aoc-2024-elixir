defmodule Advent.Year2024.Day07Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day07

  @part1_example_input "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = @part1_example_input
      %{sum: result} = part1(input)

      assert result == 3749
    end

    test "solves part 1 with fixture data" do
      input = File.read!("test/fixtures/day07p1_input.txt")
      %{sum: result} = part1(input)

      assert result == 2_941_973_819_040
    end

    test "solves part 2 with example data" do
      input = @part1_example_input
      %{sum: result} = part2(input)

      assert result == 11_387
    end

    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day07p1_input.txt")
      %{sum: result} = part2(input)

      assert result == 249_943_041_417_600
    end
  end

  describe "parse_equations/1" do
    test "returns list of results and their constituents" do
      input = @part1_example_input
      result = parse_equations(input)

      assert [
               %{values: [10, 19], result: 190},
               %{values: ~c"Q(\e", result: 3267},
               %{values: [17, 5], result: 83},
               %{values: [15, 6], result: 156},
               %{values: [6, 8, 6, 15], result: 7290},
               %{values: [16, 10, 13], result: 161_011},
               %{values: [17, 8, 14], result: 192},
               %{values: [9, 7, 18, 13], result: 21037},
               %{values: [11, 6, 16, 20], result: 292}
             ] == result
    end
  end
end
