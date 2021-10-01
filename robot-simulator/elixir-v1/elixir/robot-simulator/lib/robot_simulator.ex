defmodule RobotSimulator do

  defstruct direction: :north,
            position: {0, 0}

  defguard is_direction(direction) when direction in [:north,:east,:south,:west]

  defguard is_position(pos)
    when is_tuple(pos)
    and tuple_size(pos) == 2
    and pos |> elem(0) |> is_integer()
    and pos |> elem(1) |> is_integer()

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})
  def create(direction, _) when not is_direction(direction) do
    {:error, "invalid direction"}
  end
  def create(_, position) when not is_position(position) do
    {:error, "invalid position"}
  end
  def create(direction, position) do
    %__MODULE__{direction: direction, position: position}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, ""), do: robot
  def simulate(robot, <<command_token::utf8, rest::bytes>>) do
    with {:ok, command_atom} <- interpret_command(command_token) do
      robot
      |> execute_command(command_atom)
      |> simulate(rest)
    end
  end

  defp interpret_command(?A), do: {:ok, :advance}
  defp interpret_command(?R), do: {:ok, :right}
  defp interpret_command(?L), do: {:ok, :left}
  defp interpret_command(_), do: {:error , "invalid instruction"}

  defp execute_command(robot = %__MODULE__{direction: :north, position: {x, y}}, :advance) do
    %{ robot | position: {x, y + 1} }
  end
  defp execute_command(robot = %__MODULE__{direction: :south, position: {x, y}}, :advance) do
    %{ robot | position: {x, y - 1} }
  end
  defp execute_command(robot = %__MODULE__{direction: :east, position: {x, y}}, :advance) do
    %{ robot | position: {x + 1, y} }
  end
  defp execute_command(robot = %__MODULE__{direction: :west, position: {x, y}}, :advance) do
    %{ robot | position: {x - 1, y} }
  end

  defp execute_command(robot = %__MODULE__{direction: :north}, :left) do
    %{robot | direction: :west}
  end
  defp execute_command(robot = %__MODULE__{direction: :north}, :right) do
    %{robot | direction: :east}
  end
  defp execute_command(robot = %__MODULE__{direction: :east}, :right) do
    %{robot | direction: :south}
  end
  defp execute_command(robot = %__MODULE__{direction: :east}, :left) do
    %{robot | direction: :north}
  end
  defp execute_command(robot = %__MODULE__{direction: :south}, :right) do
    %{robot | direction: :west}
  end
  defp execute_command(robot = %__MODULE__{direction: :south}, :left) do
    %{robot | direction: :east}
  end
  defp execute_command(robot = %__MODULE__{direction: :west}, :right) do
    %{robot | direction: :north}
  end
  defp execute_command(robot = %__MODULE__{direction: :west}, :left) do
    %{robot | direction: :south}
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%__MODULE__{direction: direction}) do
    direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%__MODULE__{position: position}) do
    position
  end
end
