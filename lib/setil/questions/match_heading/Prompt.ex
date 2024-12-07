defmodule Setil.Questions.MatchHeading.Prompt do
  alias Setil.Questions.MatchHeading.Response

  @default_words 350
  @default_difficulty_level 10
  @default_no_of_options 3

  def default_config() do
    %{words: @default_words, difficulty: @default_difficulty_level}
  end

  def match_heading(words \\ @default_words, difficulty \\ @default_difficulty_level)

  def match_heading(words, difficulty)
      when is_integer(difficulty) and is_integer(words) and difficulty >= 1 and
             difficulty <= 10 and words >= 250 and words <= 900 do
    min_words = words - 50

    max_words = words

    with {:ok, result} <- do_chat_completion(min_words, max_words, difficulty) do
      {:ok, result} |> IO.inspect()
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Unknown reason"}
    end
  end

  def match_heading(_invalid_words, _invalid_difficulty_level) do
    {:error, "Malformed arguments"}
  end

  defp do_chat_completion(min_words, max_words, difficulty) do
    Instructor.chat_completion(
      model: "gpt-4o-mini",
      response_model: Response,
      # max_retries: 3,
      messages: [
        system_message(min_words, max_words),
        user_message(min_words, max_words, difficulty)
      ]
    )
  end

  defp system_message(min_words, max_words) do
    %{
      role: "system",
      content: """
      You are an examiner for the Academic IELTS Reading module. Your task is to create a passage and design a "Match the Heading" question. The passage should be between #{min_words} and #{max_words} words, with a difficulty level determined by the user (1 to 10). Based on the passage:

      1. Provide one correct heading that accurately captures the main idea of the passage.
      2. Create #{@default_no_of_options} distractor headings derived from the content of the passage. These distractors must be relevant and plausible, making it challenging to distinguish the correct heading from the distractors.

      The language, complexity, and vocabulary of the passage and headings should align with the specified difficulty level.
      """
    }
  end

  defp user_message(min_words, max_words, difficulty) do
    %{
      role: "user",
      content: """
      I'm ready for a question. The difficulty level is #{difficulty}.

      Return:
      - passage: An array of strings. Each paragraph forms a new element in the array. Passage must be #{min_words}-#{max_words} words long.
      - options: A list of #{@default_no_of_options} distractor headings. These should be plausible and derived from the passage but must not include the correct answer.
      - answer: The correct heading that best summarizes the passage.
      """
    }
  end
end
