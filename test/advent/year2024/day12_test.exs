defmodule Advent.Year2024.Day12Test do
  use ExUnit.Case

  import Elixir.Advent.Year2024.Day12

  @example_input """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  describe "integration tests" do
    test "solves part 1 with example data" do
      input = @example_input
      result = part1(input)

      assert result == 1930
    end

    test "solves part1 with fixture data" do
      input = File.read!("test/fixtures/day12p1_input.txt")
      result = part1(input)

      assert result == 1_461_752
    end

    @tag :skip
    test "solves part 2 with example data" do
      input = @example_input
      result = part2(input)

      assert result == 0
    end

    @tag :skip
    test "solves part 2 with fixture data" do
      input = File.read!("test/fixtures/day12p1_input.txt")
      result = part2(input)

      assert result == 0
    end
  end

  describe "flood_fill" do
    test "finds a simple region" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "R",
        {0, 1} => "B",
        {1, 1} => "B"
      }

      {region, visited} = find_region({0, 0}, grid, MapSet.new())

      assert region == MapSet.new([{0, 0}, {1, 0}])
      assert visited == MapSet.new([{0, 0}, {1, 0}])
    end

    test "handles single cell region" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "B",
        {0, 1} => "B",
        {1, 1} => "B"
      }

      {region, visited} = find_region({0, 0}, grid, MapSet.new())

      assert region == MapSet.new([{0, 0}])
      assert visited == MapSet.new([{0, 0}])
    end

    test "finds complex region" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "R",
        {2, 0} => "B",
        {0, 1} => "R",
        {1, 1} => "R",
        {2, 1} => "B",
        {0, 2} => "B",
        {1, 2} => "B",
        {2, 2} => "B"
      }

      {region, visited} = find_region({0, 0}, grid, MapSet.new())

      assert region == MapSet.new([{0, 0}, {1, 0}, {0, 1}, {1, 1}])
      assert visited == MapSet.new([{0, 0}, {1, 0}, {0, 1}, {1, 1}])
    end

    test "handles already visited cells" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "R",
        {0, 1} => "R",
        {1, 1} => "R"
      }

      initial_visited = MapSet.new([{0, 0}])

      {region, visited} = find_region({1, 0}, grid, initial_visited)

      assert region == MapSet.new([{1, 0}, {0, 1}, {1, 1}])
      assert MapSet.member?(visited, {0, 0})
    end

    test "respects grid boundaries" do
      grid = %{{0, 0} => "R"}

      {region, visited} = find_region({0, 0}, grid, MapSet.new())

      assert region == MapSet.new([{0, 0}])
      assert visited == MapSet.new([{0, 0}])
    end
  end

  describe "calculate_perimeter" do
    test "single cell has perimeter of 4" do
      grid = %{{0, 0} => "R"}
      region = MapSet.new([{0, 0}])

      assert calculate_perimeter(region, grid) == 4
    end

    test "two adjacent cells have perimeter of 6" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "R",
        {0, 1} => "B",
        {1, 1} => "B"
      }

      region = MapSet.new([{0, 0}, {1, 0}])

      assert calculate_perimeter(region, grid) == 6
    end

    test "2x2 square has perimeter of 8" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "R",
        {0, 1} => "R",
        {1, 1} => "R"
      }

      region = MapSet.new([{0, 0}, {1, 0}, {0, 1}, {1, 1}])

      assert calculate_perimeter(region, grid) == 8
    end

    test "L-shaped region has perimeter of 10" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "R",
        {2, 0} => "B",
        {0, 1} => "R",
        {1, 1} => "B",
        {2, 1} => "B",
        {0, 2} => "B",
        {1, 2} => "B",
        {2, 2} => "B"
      }

      region = MapSet.new([{0, 0}, {1, 0}, {0, 1}])

      assert calculate_perimeter(region, grid) == 8
    end

    test "handles region at grid edge" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "R",
        {0, 1} => "B",
        {1, 1} => "B"
      }

      region = MapSet.new([{0, 0}, {1, 0}])

      assert calculate_perimeter(region, grid) == 6
    end

    test "handles region at grid corner" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "B",
        {0, 1} => "B",
        {1, 1} => "B"
      }

      region = MapSet.new([{0, 0}])

      assert calculate_perimeter(region, grid) == 4
    end

    test "handles U-shaped region" do
      grid = %{
        {0, 0} => "R",
        {1, 0} => "B",
        {2, 0} => "R",
        {0, 1} => "R",
        {1, 1} => "B",
        {2, 1} => "R",
        {0, 2} => "R",
        {1, 2} => "R",
        {2, 2} => "R"
      }

      region = MapSet.new([{0, 0}, {2, 0}, {0, 1}, {2, 1}, {0, 2}, {1, 2}, {2, 2}])

      assert calculate_perimeter(region, grid) == 16
    end
  end
end
