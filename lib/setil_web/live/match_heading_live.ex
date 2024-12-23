defmodule SetilWeb.MatchHeadingLive do
  use SetilWeb, :live_view
  import Phoenix.Component

  alias Setil.Questions.MatchHeading.Prompt
  alias Setil.Questions.MatchHeading.Response

  @default_words 350
  @default_difficulty_level 10

  # TODO :
  # - Currently `max_retries == 0` for `Prompt`.
  # UI state is not definded when it fails on its first attempt.

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(initial_state())}
  end

  def handle_event("select-option", %{"option" => selected_option}, socket) do
    {:noreply,
     socket
     |> assign(:selected_option, selected_option)
     |> maybe_send_confetti(selected_option)}
  end

  def handle_event("set-words", %{"slider-words" => value}, socket) do
    {words, _} = Integer.parse(value)

    {:noreply,
     socket
     |> assign(:words, words)}
  end

  def handle_event("set-difficulty", %{"slider-difficulty" => value}, socket) do
    {difficulty, _} = Integer.parse(value)

    {:noreply,
     socket
     |> assign(:difficulty, difficulty)}
  end

  def handle_event("set-theme", %{"input-theme" => theme}, socket) do
    {:noreply,
     socket
     |> assign(:theme, theme)}
  end

  def handle_event("next-passage", _params, socket) do
    parent = self()
    # TODO : Process may become zombie and currently
    # there is no way to detect that and kill it!
    spawn(fn ->
      fetch_passage(parent, socket.assigns.theme, socket.assigns.words, socket.assigns.difficulty)
    end)

    {:noreply,
     socket
     |> assign(:loading, true)}
  end

  def handle_info({:fetched_passage, %Response{} = response}, socket) do
    {:noreply,
     socket
     |> assign(:loading, false)
     |> assign(:response, prepare_response(response))
     |> assign(:selected_option, nil)}
  end

  def handle_info(:error_fetching_passage, socket) do
    {:noreply,
     socket
     |> assign(:loading, false)
     |> put_flash(:error, "Error fetching passage. Try again!")}
  end

  # Private functions

  defp initial_state do
    default_prompt_config()
    |> Map.merge(%{
      page_title: "Match heading with paragraph",
      # response is a Prompt %Response{} as map rather struct.
      response: nil,
      selected_option: nil,
      loading: false
    })
  end

  defp default_prompt_config() do
    %{words: @default_words, difficulty: @default_difficulty_level, theme: nil}
  end

  defp fetch_passage(parent, theme, words, difficulty) do
    with {:ok, result} <- Prompt.match_heading(theme, words, difficulty) do
      send(parent, {:fetched_passage, result})
    else
      _ ->
        send(parent, :error_fetching_passage)
    end
  end

  defp prepare_response(%Response{passage: passage, options: options, answer: answer}) do
    %{
      passage: passage,
      options: get_shuffled_options(options, answer),
      answer: answer
    }
  end

  defp maybe_send_confetti(socket, selected_option) do
    if selected_option == socket.assigns.response.answer do
      push_event(socket, "trigger-confetti", %{type: "celebration"})
    else
      socket
    end
  end

  # Helpers

  defp get_shuffled_options(options, answer) do
    Enum.shuffle([answer | options])
  end

  defp class_when_option_selected(selected_option, option, answer) do
    if selected_option == option do
      if option == answer do
        "bg-emerald-500 text-white shadow-[4px_4px_0_0_rgba(0,0,0,1)]"
      else
        "bg-red-500 text-white shadow-[4px_4px_0_0_rgba(0,0,0,1)]"
      end
    else
      "bg-white hover:bg-gray-50 shadow-[2px_2px_0_0_rgba(0,0,0,1)]"
    end
  end
end
