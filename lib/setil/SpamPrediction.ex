defmodule Setil.SpamPrediction do
  use Ecto.Schema
  use Instructor.Validator
  # Add this line
  import Ecto.Changeset

  @doc """
  ## Field Descriptions:
  - class: Whether or not the email is spam.
  - reason: A short, less than 10 word rationalization for the classification.
  - score: A confidence score between 0.0 and 1.0 for the classification.
  """
  @primary_key false
  embedded_schema do
    field(:class, :string)
    field(:reason, :string)
    field(:score, :float)
  end

  @impl true
  def validate_changeset(changeset) do
    changeset
    |> cast(%{}, [:class, :reason, :score])
    |> validate_required([:class, :reason, :score])
    |> validate_inclusion(:class, ["spam", "not_spam"])
    |> validate_number(:score,
      greater_than_or_equal_to: 0.0,
      less_than_or_equal_to: 1.0
    )
  end
end
