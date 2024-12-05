defmodule SetilWeb.MatchHeadingLive do
  use SetilWeb, :live_view
  import Phoenix.Component

  alias Setil.Questions.MatchHeading.Prompt
  alias Setil.Questions.MatchHeading.Response

  # TODO :
  # - Currently `max_retries == 0` for `Prompt`.
  # UI state is not definded when it fails on its first attempt.

  def mount(_params, _session, socket) do
    initial_state =
      %{
        passage: [],
        loading: false,
        page_title: "Match heading with paragraph"
      }

    {:ok, assign(socket, initial_state)}
  end

  def handle_event("select_option", %{"option" => selected_option}, socket) do
    socket = assign(socket, :selected_option, selected_option)

    socket =
      if selected_option == socket.assigns.answer do
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

    {:noreply, assign(socket, loading: true, passage: [])}
  end

  def handle_info({:fetched_question, %Response{} = question}, socket) do
    socket =
      socket
      |> assign(:loading, false)
      |> assign(:passage, question.passage)
      |> assign(:options, get_shuffled_options(question.options, question.answer))
      |> assign(:answer, question.answer)
      |> assign(:selected_option, nil)

    {:noreply, socket}
  end

  def handle_info(:error_fetching_question, socket) do
    socket =
      socket
      |> assign(:loading, false)
      |> assign(:passage, [])
      |> put_flash(:error, "Error fetching question. Try again!")

    {:noreply, socket}
  end

  defp fetch_question(parent) do
    with {:ok, result} <- Prompt.question(10) do
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
