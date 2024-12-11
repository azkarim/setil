defmodule Setil.Questions.MatchHeading do
  @type t :: %__MODULE__{
          passage: list(String.t()) | nil,
          options: list(String.t()) | nil,
          answer: String.t() | nil,
          difficulty: non_neg_integer() | nil,
          max_words: non_neg_integer() | nil
        }

  defstruct passage: nil, options: nil, answer: nil, difficulty: nil, max_words: nil
end
