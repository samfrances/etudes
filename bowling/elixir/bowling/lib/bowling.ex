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

defmodule Bowling.Frame do

  defstruct [
    primary_rolls: []
  ]

  def new() do
    %__MODULE__{}
  end

  def status(%__MODULE__{primary_rolls: rolls}) do
    cond do
      Enum.sum(rolls) < 10 -> :open
      length(rolls) == 2 -> :spare
      length(rolls) == 1 -> :strike
    end
  end

  def roll(frame, n) do
    cond do
      status(frame) in [:strike, :spare] -> frame
      true -> %{
        frame |
        primary_rolls: [n|frame.primary_rolls]
      }
    end
  end

end
