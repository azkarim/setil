defmodule SetilWeb.MatchHeadingLive do
  use SetilWeb, :live_view
  import Phoenix.Component

  alias Setil.Questions.MatchHeading.Prompt
  alias Setil.Questions.MatchHeading.Response

  # TODO :
  # - Currently `max_retries == 0` for `Prompt`.
  # UI state is not definded when it fails on its first attempt.

  def mount(_params, _session, socket) do
    prompt_config = Prompt.default_config()

    page_state =
      %{
        page_title: "Match heading with paragraph",
        # response is a Prompt %Response{} as map rather struct.
        response: nil,
        selected_option: nil,
        loading: false
      }

    initial_state = Map.merge(prompt_config, page_state)

    {:ok, assign(socket, initial_state)}
  end

  def handle_event("select_option", %{"option" => selected_option}, socket) do
    socket = assign(socket, :selected_option, selected_option)

    socket =
      if selected_option == socket.assigns.response.answer do
        send_confetti(socket)
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event("next-passage", _params, socket) do
    parent = self()
    # TODO : Process may become zombie and currently
    # there is no way to detect that and kill it!
    spawn(fn -> fetch_question(parent) end)

    socket =
      socket
      |> assign(:loading, true)

    {:noreply, socket}
  end

  def handle_info(
        {:fetched_question, %Response{passage: passage, options: options, answer: answer}},
        socket
      ) do
    # modify options to include answer
    response =
      %{
        passage: passage,
        options: get_shuffled_options(options, answer),
        answer: answer
      }

    socket =
      socket
      |> assign(:loading, false)
      |> assign(:response, response)
      |> assign(:selected_option, nil)

    {:noreply, socket}
  end

  def handle_info(:error_fetching_question, socket) do
    socket =
      socket
      |> assign(:loading, false)
      |> put_flash(:error, "Error fetching question. Try again!")

    {:noreply, socket}
  end

  defp fetch_question(parent) do
    with {:ok, result} <- Prompt.match_heading() do
      send(parent, {:fetched_question, result})
    else
      _ ->
        send(parent, :error_fetching_question)
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

  defp send_confetti(socket, type \\ "celebration") do
    push_event(socket, "trigger-confetti", %{type: type})
  end
end
