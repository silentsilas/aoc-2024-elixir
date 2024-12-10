defmodule Advent.Year2024.Day08 do
  alias Advent.Grid
  @type position :: {integer, integer}
  @type grid :: %{position => String.t()}

  @spec part1(String.t()) :: integer
  def part1(input) do
    grid =
      input
      |> Grid.parse()

    {width, height} = Grid.dimensions(grid)

    # Group antennas by frequency
    antennas_by_freq =
      grid
      |> Enum.reject(fn {_, v} -> v == "." end)
      |> Enum.group_by(fn {_, freq} -> freq end, fn {pos, _} -> pos end)

    antinodes =
      antennas_by_freq
      |> Enum.flat_map(fn {_freq, antennas} ->
        for a1 <- antennas,
            a2 <- antennas,
            a1 != a2,
            do: find_antinodes(a1, a2, width, height)
      end)
      |> List.flatten()
      # remove duplicates
      |> MapSet.new()

    MapSet.size(antinodes)
  end

  def find_antinodes({x1, y1}, {x2, y2}, width, height) do
    dx = x2 - x1
    dy = y2 - y1

    # Create "antinodes" one vector distance away before and after the two antennas
    # and remove any outside the grid
    [{x1 - dx, y1 - dy}, {x2 + dx, y2 + dy}]
    |> Enum.filter(fn {x, y} ->
      x >= 0 and x < width and y >= 0 and y < height
    end)
  end

  def part2(args) do
    args
  end
end
