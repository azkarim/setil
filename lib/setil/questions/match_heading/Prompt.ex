defmodule Setil.Questions.MatchHeading.Prompt do
  alias Setil.Questions.MatchHeading.Response

  def question(difficulty_level)
      when is_integer(difficulty_level) and difficulty_level >= 1 and difficulty_level <= 10 do
    min_words = 250
    max_words = 300
    no_of_options = 3

    Instructor.chat_completion(
      model: "gpt-4o-mini",
      response_model: Response,
      # max_retries: 3,
      messages: [
        %{
          role: "system",
          content: """
          You are an examiner for the IELTS Reading module. Your task is to create a passage and design a "Match the Heading" question. The passage should be between #{min_words} and #{max_words} words, with a difficulty level determined by the user (1 to 10). Based on the passage:

          1. Provide one correct heading that accurately captures the main idea of the passage.
          2. Create #{no_of_options} distractor headings derived from the content of the passage. These distractors must be relevant and plausible, making it challenging to distinguish the correct heading from the distractors.

          The language, complexity, and vocabulary of the passage and headings should align with the specified difficulty level.
          """
        },
        %{
          role: "user",
          content: """
          I'm ready for a question. The difficulty level is #{difficulty_level}.

          Return:
          - passage: An array of strings. Each paragraph forms a new element in the array. Passage must be #{min_words}-#{max_words} words long.
          - options: A list of #{no_of_options} distractor headings. These should be plausible and derived from the passage but must not include the correct answer.
          - answer: The correct heading that best summarizes the passage.
          """
        }
      ]
    )
    |> IO.inspect()
  end

  def question(_invalid_level) do
    {:error, "Difficulty level must be an integer between 1 and 10"}
  end
end
