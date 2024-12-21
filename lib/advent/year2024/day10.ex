defmodule Advent.Year2024.Day10 do
  @type coordinate :: {non_neg_integer(), non_neg_integer()}
  @type height :: non_neg_integer()
  @type coordinate_point :: {coordinate(), height()}
  @type topography :: %{coordinate() => height()}

  def part1(input) do
    topography =
      input
      |> parse()

    trailheads =
      topography
      |> Enum.filter(fn {{_x, _y}, value} -> value == 0 end)

    trailheads
    |> Enum.map(fn starting_point ->
      paths = find_all_paths(topography, starting_point)
      reachable_peaks = count_reachable_peaks(paths)
      {starting_point, MapSet.size(reachable_peaks)}
    end)
    |> Enum.reduce(0, fn {_, peak_count}, acc -> acc + peak_count end)
  end

  def part2(input) do
    topography =
      input
      |> parse()

    trailheads =
      topography
      |> Enum.filter(fn {{_x, _y}, value} -> value == 0 end)

    trailheads
    |> Enum.map(fn starting_point ->
      paths = find_all_paths(topography, starting_point)

      {starting_point, length(paths)}
    end)
    |> Enum.reduce(0, fn {_, peak_count}, acc -> acc + peak_count end)
  end

  defp count_reachable_peaks(paths) do
    paths
    # Get coords of 9 (peak) in each path
    |> Enum.map(&List.first/1)
    |> Enum.map(&elem(&1, 0))
    # Multiple paths may lead to the same peak
    # So dedupe the list of peak coordinates
    |> MapSet.new()
  end

  @spec parse(String.t()) :: topography()
  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Stream.with_index()
      |> Stream.map(fn {value, x} ->
        {{x, y}, String.to_integer(value)}
      end)
    end)
    |> Enum.into(%{})
  end

  @spec find_all_paths(topography(), coordinate_point()) :: [[coordinate_point()]]
  defp find_all_paths(topography, starting_point) do
    {starting_coord, _} = starting_point

    find_paths(
      topography,
      starting_point,
      [starting_point],
      MapSet.new([starting_coord])
    )
  end

  @spec find_paths(topography(), coordinate_point(), [coordinate_point()], MapSet.t(coordinate())) ::
          [[coordinate_point()]]
  defp find_paths(topography, {current_coord, current_height}, path, visited) do
    if current_height == 9 do
      [path]
    else
      check_neighbors(topography, current_coord, current_height, visited)
      |> Enum.flat_map(fn valid_neighbor_point ->
        {valid_neighbor_coord, _} = valid_neighbor_point

        find_paths(
          topography,
          valid_neighbor_point,
          [valid_neighbor_point | path],
          MapSet.put(visited, valid_neighbor_coord)
        )
      end)
    end
  end

  @spec check_neighbors(topography(), coordinate(), height(), MapSet.t(coordinate())) :: [
          coordinate_point()
        ]
  defp check_neighbors(topography, {current_x, current_y}, current_height, visited) do
    [
      {current_x - 1, current_y},
      {current_x + 1, current_y},
      {current_x, current_y - 1},
      {current_x, current_y + 1}
    ]
    |> Enum.filter(fn neighbor_coord ->
      case Map.get(topography, neighbor_coord) do
        nil ->
          false

        neighbor_height ->
          not MapSet.member?(visited, neighbor_coord) and
            neighbor_height == current_height + 1
      end
    end)
    |> Enum.map(fn neighbor_coord -> {neighbor_coord, Map.get(topography, neighbor_coord)} end)
  end
end
