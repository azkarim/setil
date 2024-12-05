defmodule Setil.Questions.MatchHeading.Response do
  use Ecto.Schema
  use Instructor.Validator
  import Ecto.Changeset

  @no_of_options 3

  @doc """
  ## Field Descriptions:
  - passage: Passage question set by the examiner.
  - options: @no_of_options possible headings that may pair with the passage.
  - answer: Correct heading.
  """
  @primary_key false
  embedded_schema do
    field(:passage, {:array, :string})
    field(:options, {:array, :string})
    field(:answer, :string)
  end

  @impl true
  def validate_changeset(changeset) do
    changeset
    |> cast(%{}, [:passage, :options, :answer])
    |> validate_required([:passage, :options, :answer])
    |> validate_length(:options,
      is: @no_of_options,
      message: "must have exactly #{@no_of_options} options"
    )
  end
end
