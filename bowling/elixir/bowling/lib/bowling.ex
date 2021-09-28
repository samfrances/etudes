defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  defstruct [
    frames: []
  ]

  @spec start() :: any
  def start do
    %__MODULE__{
      frames: [Bowling.OpenFrame.new()]
    }
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll(_game, n) when n < 0 do
    {:error, "Negative roll is invalid"}
  end
  def roll(game, roll) do
    with :ok <- assert_game_ongoing(game, "Cannot roll after game is over"),
         {:ok, with_updated_scores} <- update_frames(game.frames, roll),
         next_frames <- maybe_add_next_frame(with_updated_scores)
    do
      {:ok, %{game | frames: next_frames}}
    end
  end

  defp update_frames(frames, roll) do
    updated_frames =
      Enum.map(frames, fn frame -> Bowling.Frame.roll(frame, roll) end)

    error = updated_frames |> Enum.find(fn frame ->
      case frame do
        {:error, msg} -> {:error, msg}
        _ -> nil
      end
    end)

    cond do
      is_nil(error) -> {:ok, updated_frames}
      true -> error
    end

  end

  defp maybe_add_next_frame(frames) do
    if length(frames) < 10 and Enum.all?(frames, &Bowling.Frame.finished?/1) do
      [Bowling.OpenFrame.new() | frames]
    else
      frames
    end
  end

  defp assert_game_ongoing(game, msg) do
    if game_over?(game) do
      {:error, msg}
    else
      :ok
    end
  end

  defp game_over?(%__MODULE__{frames: frames}) do
    length(frames) == 10 and Enum.all?(frames, &Bowling.Frame.fully_scored?/1)
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @spec score(any) :: {:ok, integer} | {:error, String.t()}
  def score(game) do
    if not game_over?(game) do
      {:error, "Score cannot be taken until the end of the game"}
    else
      score =
        game.frames
        |> Enum.map(&Bowling.Frame.score/1)
        |> Enum.sum()
      {:ok, score}
    end
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

  defstruct [
    next_roll: nil
  ]

  def new() do
    %__MODULE__{}
  end

end

defmodule Bowling.Strike do

  defstruct [
    first_scoring_roll: nil,
    second_scoring_roll: nil
  ]

  def new() do
    %__MODULE__{}
  end

end

defprotocol Bowling.Frame do
  def status(frame)
  def roll(frame, n)
  def score(frame)
  def finished?(frame)
  def fully_scored?(frame)
end

defimpl Bowling.Frame, for: Bowling.OpenFrame do

  def status(_frame), do: :open

  def finished?(%Bowling.OpenFrame{rolls: rolls}) do
    rolls == 2
  end

  def fully_scored?(frame) do
    finished?(frame)
  end

  def score(%Bowling.OpenFrame{rolls: rolls}) when rolls < 2 do
    nil
  end
  def score(%Bowling.OpenFrame{first_roll: x, second_roll: y}) do
    x + y
  end

  def roll(%Bowling.OpenFrame{rolls: 0}, 10) do
    Bowling.Strike.new()
  end

  def roll(_frame, n) when n > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end
  def roll(frame = %Bowling.OpenFrame{rolls: 0}, n) do
    %{ frame | first_roll: n, rolls: 1 }
  end

  def roll(%Bowling.OpenFrame{rolls: 1, first_roll: f}, n) when f + n == 10 do
    Bowling.Spare.new()
  end
  def roll(%Bowling.OpenFrame{rolls: 1, first_roll: f}, n) when f + n > 10 do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def roll(frame = %Bowling.OpenFrame{rolls: 1}, n)  do
    %{ frame | second_roll: n, rolls: 2 }
  end

  def roll(frame = %Bowling.OpenFrame{}, _n), do: frame

end

defimpl Bowling.Frame, for: Bowling.Spare do

  def status(_frame), do: :spare

  def finished?(_frame), do: true

  def fully_scored?(frame) do
    is_integer(frame.next_roll)
  end

  def roll(frame = %Bowling.Spare{next_roll: nil}, n) do
    %{frame | next_roll: n}
  end
  def roll(frame, _n) do
    frame
  end

  def score(%Bowling.Spare{next_roll: nil}) do
    nil
  end
  def score(%Bowling.Spare{next_roll: n}) do
    10 + n
  end

end

defimpl Bowling.Frame, for: Bowling.Strike do

  def status(_frame), do: :strike

  def finished?(_frame), do: true

  def fully_scored?(frame) do
    is_integer(frame.first_scoring_roll) and is_integer(frame.second_scoring_roll)
  end

  def roll(frame = %Bowling.Strike{first_scoring_roll: nil}, n) do
    %{ frame | first_scoring_roll: n }
  end
  def roll(frame = %Bowling.Strike{second_scoring_roll: nil}, n) do
    %{ frame | second_scoring_roll: n }
  end
  def roll(frame, _n) do
    frame
  end

  def score(%Bowling.Strike{first_scoring_roll: n, second_scoring_roll: m}) when is_nil(n) or is_nil(m) do
    nil
  end
  def score(%Bowling.Strike{first_scoring_roll: n, second_scoring_roll: m}) do
    n + m + 10
  end

end
