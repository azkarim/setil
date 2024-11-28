defmodule Setil.Instruct do
  alias Setil.Passage

  def question(difficulty_level)
      when is_integer(difficulty_level) and difficulty_level >= 1 and difficulty_level <= 10 do
    min_words = 250
    max_words = 300
    no_of_options = 3

    Instructor.chat_completion(
      model: "gpt-4o-mini",
      response_model: Passage,
      max_retries: 3,
      messages: [
        %{
          role: "system",
          content: """
          You are an examiner for IELTS Reading module. You will set a question which is a passage. The passage is #{min_words}-#{max_words} words long. The user is asked to pair correct heading with the passage. You will provide #{no_of_options} options as distractor headings and correct heading as answer. Headings should be relevant enough as to hard to infer the correct one. User will provide difficulty level from 1 to 10, based on which wording of the passage and respective answer should be set.
          """
        },
        %{
          role: "user",
          content: """
          I'm ready for question. Difficulty level #{difficulty_level}.

          Return:
          - passage: must be #{min_words}-#{max_words} words long
          - options: #{no_of_options} options as distractor headings. Should not contain the answer.
          - answer: the correct heading.
          """
        }
      ]
    )
  end

  def question(_invalid_level) do
    {:error, "Difficulty level must be an integer between 1 and 10"}
  end
end
