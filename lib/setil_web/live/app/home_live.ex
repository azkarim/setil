defmodule SetilWeb.App.HomeLive do
  use SetilWeb, :live_view

  import SetilWeb.App.Components.ModuleButton

  def mount(_params, session, socket) do
    {:ok, assign(socket, initial_state(session))}
  end

  def initial_state(session) do
    %{preferred_name: session["preferred_name"]}
  end
end
