defmodule Setil.Reading.MatchHeading.Prompt do
  alias Setil.Reading.MatchHeading.Response

  @default_no_of_options 3

  def match_heading(theme, words, difficulty)
      when is_integer(difficulty) and is_integer(words) and difficulty >= 1 and
             difficulty <= 10 and words >= 250 and words <= 900 do
    min_words = words - 50

    max_words = words

    with {:ok, result} <- do_chat_completion(theme, min_words, max_words, difficulty) do
      {:ok, result} |> IO.inspect()
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Unknown reason"}
    end
  end

  def match_heading(_topic, _invalid_words, _invalid_difficulty_level) do
    {:error, "Malformed arguments"}
  end

  defp do_chat_completion(theme, min_words, max_words, difficulty) do
    Instructor.chat_completion(
      model: "gpt-4o-mini",
      response_model: Response,
      # max_retries: 3,
      messages: [
        system_message(theme, min_words, max_words),
        user_message(theme, min_words, max_words, difficulty)
      ]
    )
  end

  defp system_message(theme, min_words, max_words) do
    theme_prompt0 =
      if theme do
        "The passage should embody the zest of the theme \"#{theme}\" and "
      else
        "The passage "
      end

    theme_prompt1 =
      if theme do
        "Ensure that the correct heading does not contain exact theme terms to make the task challenging for students."
      else
        ""
      end

    %{
      role: "system",
      content: """
      You are an examiner for the Academic IELTS Reading module. Your task is to create a passage and design a "Match the Heading" question. #{theme_prompt0} should be between #{min_words} and #{max_words} words, with a difficulty level determined by the user (1 to 10). Based on the passage:

      1. Provide one correct heading that accurately captures the main idea of the passage. #{theme_prompt1}
      2. Create #{@default_no_of_options} distractor headings derived from the content of the passage. These distractors must be relevant and plausible, making it challenging to distinguish the correct heading from the distractors.

      The language, complexity, and vocabulary of the passage and headings should align with the specified difficulty level.
      """
    }
  end

  defp user_message(theme, min_words, max_words, difficulty) do
    theme_prompt =
      if theme do
        ", and the theme is \"#{theme}.\""
      else
        "."
      end

    %{
      role: "user",
      content: """
      I'm ready for a question. The difficulty level is #{difficulty} #{theme_prompt}

      Return:
      - passage: An array of strings. Each paragraph forms a new element in the array. Passage must be #{min_words}-#{max_words} words long.
      - options: A list of #{@default_no_of_options} distractor headings. These should be plausible and derived from the passage but must not include the correct answer.
      - answer: The correct heading that best summarizes the passage.
      """
    }
  end
end
