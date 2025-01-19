defmodule SetilWeb.App.HomeLive do
  use SetilWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, assign(socket, initial_state(session))}
  end

  def handle_event("show_account_dropdown", _unsigned_params, socket) do
    {:noreply, assign(socket, show_account_dropdown: true)}
  end

  def handle_event("goto-profile", _unsigned_params, socket) do
    {:noreply,
     socket
     |> assign(show_account_dropdown: false)
     |> push_navigate(to: ~p"/app/settings")}
  end

  def handle_event("goto-logout", _unsigned_params, socket) do
    {:noreply, socket}
  end

  def handle_event("close-account-dropdown", _unsigned_params, socket) do
    {:noreply, assign(socket, show_account_dropdown: false)}
  end

  def initial_state(session) do
    %{show_account_dropdown: false, preferred_name: session["preferred_name"]}
  end

  # Components

  attr :label, :string, required: true
  attr :icon, :string, required: true
  attr :phx_click, :string, required: true

  def account_dropdown_item(assigns) do
    assigns =
      assign(
        assigns,
        :item_class,
        "flex items-center px-2 py-2 gap-2 text-gray-700 hover:bg-gray-100 border-2 border-gray-900 shadow-lg shadow-sm-brutal hover:translate-x-1 hover:translate-y-1 transition-all cursor-pointer"
      )

    ~H"""
    <%= if @phx_click == "goto-logout" do %>
      <.link href={~p"/users/log_out"} method="delete" class={@item_class}>
        <.icon name={@icon} class="h-5 w-5" />
        <span><%= @label %></span>
      </.link>
    <% else %>
      <div class={@item_class}>
        <.icon name={@icon} class="h-5 w-5" />
        <button phx-click={@phx_click}><%= @label %></button>
      </div>
    <% end %>
    """
  end
end
