defmodule SetilWeb.MatchHeadingLive do
  use SetilWeb, :live_view
  import Phoenix.Component

  alias Setil.Instruct
  alias Setil.Passage

  def mount(_params, _session, socket) do
    initial_state =
      %{passage: [], loading: false}

    {:ok, assign(socket, initial_state)}
  end

  def handle_event("select_option", %{"option" => selected_option}, socket) do
    {:noreply, assign(socket, :selected_option, selected_option)}
  end

  def handle_event("next-passage", _params, socket) do
    Task.async(fn -> fetch_question() end)

    {:noreply, assign(socket, loading: true, passage: [])}
  end

  def handle_info({ref, {:ok, %Passage{} = question}}, socket) when is_reference(ref) do
    Process.demonitor(ref, [:flush])

    socket =
      socket
      |> assign(:loading, false)
      |> assign(:passage, question.passage)
      |> assign(:options, get_shuffled_options(question.options, question.answer))
      |> assign(:answer, question.answer)
      |> assign(:selected_option, nil)

    {:noreply, socket}
  end

  def handle_info({ref, nil}, socket) when is_reference(ref) do
    Process.demonitor(ref, [:flush])

    socket =
      socket
      |> assign(:loading, false)
      |> assign(:passage, [])

    {:noreply, socket}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, socket) do
    {:noreply, assign(socket, loading: false, error: "Failed to fetch question")}
  end

  def fetch_question() do
    with {:ok, result} <- Instruct.question(10) do
      {:ok, result}
    else
      _ ->
        nil
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
end
