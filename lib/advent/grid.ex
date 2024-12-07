defmodule Advent.Grid do
  @moduledoc """
  A module for working with string representations of 2D grids.
  """

  @type position :: {integer, integer}
  @type grid :: %{position => String.t()}

  @doc """
  Parses a string representation of a 2D grid into a map with coordinate tuples as keys.

  ## Example:
      iex> grid = \"\"\"
      ...> .#.
      ...> #..
      ...> ..#
      ...> \"\"\"
      iex> Grid.parse(grid)
      %{
        {0, 0} => ".", {1, 0} => "#", {2, 0} => ".",
        {0, 1} => "#", {1, 1} => ".", {2, 1} => ".",
        {0, 2} => ".", {1, 2} => ".", {2, 2} => "#"
      }
  """
  @spec parse(String.t()) :: grid
  def parse(input) when is_binary(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, row_acc ->
        Map.put(row_acc, {x, y}, char)
      end)
    end)
  end

  @doc """
  Gets the dimensions of the grid as {width, height}
  """
  @spec dimensions(grid) :: {integer, integer}
  def dimensions(grid) do
    positions = Map.keys(grid)
    {max_x, _} = Enum.max_by(positions, fn {x, _} -> x end)
    {_, max_y} = Enum.max_by(positions, fn {_, y} -> y end)
    {max_x + 1, max_y + 1}
  end
end
