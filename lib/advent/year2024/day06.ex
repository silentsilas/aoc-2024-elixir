defmodule Advent.Year2024.Day06 do
  alias Advent.Year2024.Day06.GuardPatrol

  @spec part1(String.t()) :: non_neg_integer
  def part1(input) do
    {:ok, pid} = GuardPatrol.start_link(input)
    GuardPatrol.simulate_until_exit(pid)
  end

  # not implemented
  def part2(args) do
    args
  end
end

defmodule Advent.Year2024.Day06.GuardPatrol do
  use GenServer
  alias Advent.Grid

  @type position :: {integer, integer}
  @type direction :: :up | :right | :down | :left
  @type step_result :: {:continue, state} | {:exit, state}

  @type state :: %{
          grid: Grid.grid(),
          position: position,
          direction: direction,
          visited: MapSet.t(position),
          width: non_neg_integer,
          height: non_neg_integer,
          steps: non_neg_integer
        }

  # Client API

  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(initial_map) do
    GenServer.start_link(__MODULE__, initial_map)
  end

  @spec get_visited_count(GenServer.server()) :: non_neg_integer
  def get_visited_count(pid) do
    GenServer.call(pid, :get_visited_count)
  end

  @spec simulate_until_exit(GenServer.server()) :: non_neg_integer
  def simulate_until_exit(pid) do
    case GenServer.call(pid, :simulate_step, :infinity) do
      :continuing -> simulate_until_exit(pid)
      {:finished, count} -> count
    end
  end

  @spec get_state(GenServer.server()) :: state
  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  # Server Callbacks

  @impl true
  @spec init(String.t()) :: {:ok, state}
  def init(input) do
    grid = Grid.parse(input)
    {start_pos, start_dir} = find_start_position(grid)
    {width, height} = Grid.dimensions(grid)

    state = %{
      grid: grid,
      position: start_pos,
      direction: start_dir,
      visited: MapSet.new([start_pos]),
      width: width,
      height: height,
      steps: 0
    }

    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:simulate_step, _from, state) do
    case step(state) do
      {:continue, new_state} ->
        {:reply, :continuing, new_state}

      {:exit, final_state} ->
        {:reply, {:finished, MapSet.size(final_state.visited)}, final_state}
    end
  end

  @impl true
  def handle_call(:get_visited_count, _from, state) do
    {:reply, MapSet.size(state.visited), state}
  end

  # Private Functions

  @spec find_start_position(Grid.grid()) :: {position, direction}
  defp find_start_position(grid) do
    Enum.find_value(grid, fn {pos, char} ->
      case char do
        "^" -> {pos, :up}
        _ -> nil
      end
    end)
  end

  @spec step(state) :: step_result
  defp step(state) do
    next_pos = get_next_position(state.position, state.direction)
    new_state = %{state | steps: state.steps + 1}

    cond do
      out_of_bounds?(next_pos, state) ->
        {:exit, new_state}

      obstacle_ahead?(next_pos, state) ->
        # don't update with new position, but run again with new direction
        new_direction = turn_right(state.direction)
        {:continue, %{new_state | direction: new_direction}}

      true ->
        updated_state = %{
          new_state
          | position: next_pos,
            visited: MapSet.put(new_state.visited, next_pos)
        }

        {:continue, updated_state}
    end
  end

  @spec get_next_position(position, direction) :: position
  defp get_next_position({x, y}, direction) do
    case direction do
      :up -> {x, y - 1}
      :right -> {x + 1, y}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
    end
  end

  @spec turn_right(direction) :: direction
  defp turn_right(direction) do
    case direction do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  @spec out_of_bounds?(position, state) :: boolean
  defp out_of_bounds?({x, y}, state) do
    x < 0 || y < 0 || x >= state.width || y >= state.height
  end

  @spec obstacle_ahead?(position, state) :: boolean
  defp obstacle_ahead?(pos, state) do
    Map.get(state.grid, pos) == "#"
  end

  @doc """
  Prints a visual representation of the current state of the grid,
  showing the guard's position (G), visited positions (X), and obstacles (#).
  """
  def print_path(state) do
    {width, height} = {state.width, state.height}

    for y <- 0..(height - 1) do
      for x <- 0..(width - 1) do
        pos = {x, y}

        cond do
          pos == state.position -> "G"
          MapSet.member?(state.visited, pos) -> "X"
          Map.get(state.grid, pos) == "#" -> "#"
          true -> "."
        end
      end
      |> Enum.join("")
      |> IO.puts()
    end

    :ok
  end
end
