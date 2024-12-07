defmodule Advent.Year2024.Day06 do
  alias Advent.Year2024.Day06.GuardPatrol

  @spec part1(String.t()) :: non_neg_integer
  def part1(input) do
    {:ok, pid} = GuardPatrol.start_link(input)
    GuardPatrol.simulate_until_exit(pid)
  end

  def part2(input) do
    {:ok, pid} = GuardPatrol.start_link(input)
    initial_state = GuardPatrol.get_state(pid)

    empty_positions = find_empty_positions(initial_state)

    # Process positions in parallel chunks
    empty_positions
    |> process_positions_concurrently(input)
    |> Stream.filter(fn {:ok, result} -> result end)
    |> Enum.count()
  end

  defp find_empty_positions(%{width: w, height: h, grid: grid, start_pos: start_pos}) do
    for x <- 0..(w - 1),
        y <- 0..(h - 1),
        pos = {x, y},
        pos != start_pos,
        Map.get(grid, pos) == ".",
        do: pos
  end

  defp process_positions_concurrently(positions, input) do
    Task.async_stream(
      positions,
      &check_position(&1, input),
      ordered: false,
      timeout: :infinity
    )
  end

  defp check_position(pos, input) do
    {:ok, worker_pid} = GuardPatrol.start_link(input)

    case GuardPatrol.simulate_with_obstacle(worker_pid, pos) do
      {:loop, _} -> true
      _ -> false
    end
  end
end

defmodule Advent.Year2024.Day06.GuardPatrol do
  use GenServer
  alias Advent.Grid

  @type position :: {integer, integer}
  @type direction :: :up | :right | :down | :left
  @type step_result :: {:continue, state} | {:exit, state} | {:loop, state}

  @type state :: %{
          grid: Grid.grid(),
          position: position,
          direction: direction,
          visited: MapSet.t(position),
          visited_states: MapSet.t({position, direction}),
          width: non_neg_integer,
          height: non_neg_integer,
          steps: non_neg_integer,
          start_pos: position
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

  @spec simulate_with_obstacle(GenServer.server(), position) :: {:loop, state} | {:exit, state}
  def simulate_with_obstacle(pid, obstacle_pos) do
    GenServer.call(pid, {:simulate_with_obstacle, obstacle_pos}, :infinity)
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
      visited_states: MapSet.new([{start_pos, start_dir}]),
      width: width,
      height: height,
      steps: 0,
      start_pos: start_pos
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
  def handle_call({:simulate_with_obstacle, pos}, _from, state) do
    # Create new grid with temporary obstacle
    temp_grid = Map.put(state.grid, pos, "#")

    new_state = %{
      state
      | grid: temp_grid,
        position: state.start_pos,
        direction: :up,
        visited: MapSet.new([state.start_pos]),
        visited_states: MapSet.new([{state.start_pos, :up}]),
        steps: 0
    }

    result = simulate_until_done(new_state)

    {:reply, result, state}
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

  @spec simulate_until_done(state) :: {:loop, state} | {:exit, state}
  defp simulate_until_done(state) do
    case step(state) do
      {:continue, new_state} -> simulate_until_done(new_state)
      other -> other
    end
  end

  @spec step(state) :: step_result
  defp step(state) do
    next_pos = get_next_position(state.position, state.direction)
    new_state = %{state | steps: state.steps + 1}

    cond do
      out_of_bounds?(next_pos, state) ->
        {:exit, new_state}

      obstacle_ahead?(next_pos, state) ->
        new_direction = turn_right(state.direction)
        new_state = %{new_state | direction: new_direction}

        # Check for loop
        state_key = {state.position, new_direction}

        # If we've already visited this position with this direction, we're in a loop
        if MapSet.member?(state.visited_states, state_key) do
          {:loop, new_state}
        else
          {:continue,
           %{new_state | visited_states: MapSet.put(new_state.visited_states, state_key)}}
        end

      true ->
        updated_state = %{
          new_state
          | position: next_pos,
            visited: MapSet.put(new_state.visited, next_pos),
            visited_states: MapSet.put(new_state.visited_states, {next_pos, new_state.direction})
        }

        # Check for loop
        state_key = {next_pos, updated_state.direction}

        if MapSet.member?(state.visited_states, state_key) do
          {:loop, updated_state}
        else
          {:continue, updated_state}
        end
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
