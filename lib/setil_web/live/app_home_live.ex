defmodule SetilWeb.AppHomeLive do
  use SetilWeb, :live_view

  def mount(_params, session, socket) do
    preferred_name = session["preferred_name"]

    {:ok, assign(socket, :preferred_name, preferred_name)}
  end
end
