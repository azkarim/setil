defmodule Setil.Instruct do
  alias Setil.SpamPrediction

  def is_spam?(text) do
    Instructor.chat_completion(
      model: "gpt-4o-mini",
      # model: "gpt-3.5-turbo",
      response_model: SpamPrediction,
      max_retries: 3,
      messages: [
        %{
          role: "system",
          content: """
          You are a spam detection system for a clothing retail business.
          Analyze customer support emails and classify them as spam or not spam.
          Provide a confidence score between 0.0 and 1.0, and a brief reason (less than 10 words) for your classification.
          """
        },
        %{
          role: "user",
          content: """
          Please classify this email:
          ```
          #{text}
          ```

          Return:
          - class: must be exactly "spam" or "not_spam"
          - score: a float between 0.0 and 1.0 indicating confidence
          - reason: brief explanation (less than 10 words)
          """
        }
      ]
    )
  end
end
