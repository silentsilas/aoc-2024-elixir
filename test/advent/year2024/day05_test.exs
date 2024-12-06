defmodule Advent.Year2024.Day05Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day05

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"
      result = part1(input)

      assert result == 143
    end

    test "solves part 1 with fixture data" do
      input = File.read!("test/fixtures/day05p1_input.txt")
      result = part1(input)

      assert result == 5208
    end

    @tag :skip
    test "solves part 2 with example data" do
      input = nil
      result = part2(input)

      assert result
    end
  end

  describe "parse_rules/1" do
    test "parses rules correctly" do
      input = "1|2\n3|4\n5|6"

      expected = [
        %{leading: 1, trailing: 2},
        %{leading: 3, trailing: 4},
        %{leading: 5, trailing: 6}
      ]

      assert parse_rules(input) == expected
    end
  end

  describe "parse_ordering/1" do
    test "parses multiple orderings correctly" do
      input = "1,2,3\n4,5,6\n7,8,9"
      expected = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      assert parse_ordering(input) == expected
    end
  end

  describe "valid_orderings/2" do
    test "filters valid orderings based on rules" do
      rules = [%{leading: 1, trailing: 3}]

      orderings = [
        # valid
        [1, 2, 3],
        # invalid
        [3, 2, 1],
        # valid
        [2, 1, 3],
        # valid (rule doesn't apply)
        [4, 5, 6]
      ]

      assert length(valid_orderings(rules, orderings)) == 3
    end

    test "handles multiple rules" do
      rules = [
        %{leading: 1, trailing: 3},
        %{leading: 2, trailing: 4}
      ]

      orderings = [
        # valid
        [1, 2, 3, 4],
        # invalid
        [4, 3, 2, 1],
        # invalid
        [1, 4, 2, 3]
      ]

      assert length(valid_orderings(rules, orderings)) == 1
    end
  end

  describe "sum_middle_values/1" do
    test "calculates middle value sum correctly" do
      orderings = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]

      # 2 + 5 + 8
      assert sum_middle_values(orderings) == 15
    end
  end
end
