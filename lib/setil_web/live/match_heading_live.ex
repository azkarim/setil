defmodule SetilWeb.MatchHeadingLive do
  use SetilWeb, :live_view
  import Phoenix.Component

  alias Setil.Instruct
  alias Setil.Passage

  # TODO :
  # - Currently `max_retries == 0` for `Instruct`.
  # UI state is not definded when it fails on its first attempt.

  def mount(_params, _session, socket) do
    initial_state =
      %{passage: [], loading: false}

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
    # Warning : Process may become zombie and currently
    # there is no way to detect that and kill it!
    spawn(fn -> fetch_question(parent) end)

    {:noreply, assign(socket, loading: true, passage: [])}
  end

  def handle_info({:fetched_question, %Passage{} = question}, socket) do
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

  def fetch_question(parent) do
    with {:ok, result} <- Instruct.question(10) do
      send(parent, {:fetched_question, result})
    else
      _ ->
        send(parent, :error_fetching_question)
    end
  end

  # Helpers

  def get_shuffled_options(options, answer) do
    Enum.shuffle([answer | options])
  end

  def input_class_when_option_selected(selected_option, option, answer) do
    if selected_option == option do
      if option == answer do
        "text-green-600 border-green-200 focus:ring-green-500"
      else
        "text-red-600 border-red-200 focus:ring-red-500"
      end
    else
      "text-blue-600 border-gray-200 focus:ring-blue-500"
    end
  end

  def label_class_when_option_selected(selected_option, option, answer) do
    if selected_option == option do
      if option == answer do
        "text-white bg-green-500 border-green-200 focus:border-green-500 focus:ring-green-500"
      else
        "text-white bg-red-500 border-red-200  focus:border-red-500 focus:ring-red-500"
      end
    else
      "text-gray-500 bg-white border-gray-200  focus:border-blue-500 focus:ring-blue-500"
    end
  end

  defp send_confetti(socket, type \\ "celebration") do
    push_event(socket, "trigger-confetti", %{type: type})
  end
end
