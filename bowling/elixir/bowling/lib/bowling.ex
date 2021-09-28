defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll(game, roll) do
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @spec score(any) :: {:ok, integer} | {:error, String.t()}
  def score(game) do
  end
end

defmodule Bowling.OpenFrame do

  defstruct [
    first_roll: 0,
    second_roll: 0,
    rolls: 0
  ]

  def new() do
    %__MODULE__{}
  end

end

defmodule Bowling.Spare do

  defstruct []

  def new() do
    %__MODULE__{}
  end

end

defmodule Bowling.Strike do

  defstruct []

  def new() do
    %__MODULE__{}
  end

end

defprotocol Bowling.Frame do
  def status(frame)
  def roll(frame, n)
  def score(frame)
  # def finished(frame)
  # def fully_scored(frame)
end

defimpl Bowling.Frame, for: Bowling.OpenFrame do

  def status(_frame), do: :open

  def score(%Bowling.OpenFrame{rolls: rolls}) when rolls < 2 do
    nil
  end
  def score(%Bowling.OpenFrame{first_roll: x, second_roll: y}) do
    x + y
  end

  def roll(%Bowling.OpenFrame{rolls: 0}, 10) do
    Bowling.Strike.new()
  end

  def roll(frame = %Bowling.OpenFrame{rolls: 0}, n) do
    %{ frame | first_roll: n, rolls: 1 }
  end

  def roll(%Bowling.OpenFrame{rolls: 1, first_roll: f}, n) when f + n == 10 do
    Bowling.Spare.new()
  end

  def roll(frame = %Bowling.OpenFrame{rolls: 1}, n)  do
    %{ frame | second_roll: n, rolls: 2 }
  end

  def roll(frame = %Bowling.OpenFrame{}, _n), do: frame

end

defimpl Bowling.Frame, for: Bowling.Spare do

  def status(_frame), do: :spare

  def roll(frame, _n) do
    frame
  end

  def score(_frame) do
    0
  end

end

defimpl Bowling.Frame, for: Bowling.Strike do

  def status(_frame), do: :strike

  def roll(frame, _n) do
    frame
  end

  def score(_frame) do
    0
  end

end
