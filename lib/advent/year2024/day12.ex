defmodule Advent.Year2024.Day12 do
  alias Advent.Grid

  @type region :: %{
          character: String.t(),
          coordinates: MapSet.t(Grid.position()),
          perimeter: non_neg_integer()
        }

  def part1(input) do
    grid = Grid.parse(input)

    grid
    |> Map.keys()
    |> find_regions(grid, [], MapSet.new())
    |> Enum.reduce(0, fn %{coordinates: coords, perimeter: perimeter}, acc ->
      price = Enum.count(coords) * perimeter
      acc + price
    end)
  end

  # base case
  def find_regions([], _grid, regions, _visited) do
    regions
  end

  # loop
  def find_regions([coord | rest], grid, regions, visited) do
    if MapSet.member?(visited, coord) do
      find_regions(rest, grid, regions, visited)
    else
      {region, visited} = find_region(coord, grid, visited)

      perimeter = calculate_perimeter(region, grid)

      new_region = %{
        character: Map.get(grid, coord),
        coordinates: region,
        perimeter: perimeter
      }

      find_regions(rest, grid, [new_region | regions], visited)
    end
  end

  # flood fill alg
  def find_region(coord, grid, visited) do
    flood_fill([coord], grid, MapSet.new(), visited)
  end

  def flood_fill([], _grid, region, visited) do
    {region, visited}
  end

  def flood_fill([coord | rest], grid, region, visited) do
    if MapSet.member?(visited, coord) do
      flood_fill(rest, grid, region, visited)
    else
      neighbors = Grid.get_neighbors(coord)

      matching_neighbors =
        Enum.filter(neighbors, fn {x, y} -> Map.get(grid, {x, y}) == Map.get(grid, coord) end)

      flood_fill(
        matching_neighbors ++ rest,
        grid,
        MapSet.put(region, coord),
        MapSet.put(visited, coord)
      )
    end
  end

  def calculate_perimeter(region, grid) do
    region
    |> Enum.reduce(0, fn coord, acc ->
      boundaries =
        Grid.get_neighbors(coord)
        |> Enum.filter(fn {x, y} ->
          Map.get(grid, {x, y}) != Map.get(grid, coord)
        end)

      acc + length(boundaries)
    end)
  end

  def part2(_input), do: :not_implemented
end
