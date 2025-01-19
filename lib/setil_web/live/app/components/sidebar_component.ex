defmodule SetilWeb.App.Components.SidebarComponent do
  use SetilWeb, :live_component

  def update(assigns, socket) do
    {:ok, assign(socket, assigns) |> assign(:show_account_dropdown, false)}
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

  # Components
  attr :label, :string, required: true
  attr :icon, :string, required: true
  attr :phx_click, :string, required: true
  attr :myself, :any, required: true

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
      <button phx-click={@phx_click} phx-target={@myself} class="w-full">
        <div class={[@item_class, "w-full"]}>
          <.icon name={@icon} class="h-5 w-5" />
          <%= @label %>
        </div>
      </button>
    <% end %>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="w-16 h-full py-12 flex flex-col items-center justify-between" id={@id}>
      <div>
        <.link
          href={~p"/app/"}
          class="h-10 w-10 bg-white rounded-full border-2 border-gray-900 flex items-center justify-center hover:-translate-y-0.5 transition-transform cursor-pointer shadow-sm-brutal"
        >
          <.icon name="hero-home-solid" class="h-5 w-5" />
        </.link>
      </div>
      <div class="relative group">
        <button
          class="h-10 w-10 bg-white rounded-full border-2 border-gray-900 flex items-center justify-center hover:-translate-y-0.5 transition-transform cursor-pointer shadow-sm-brutal"
          phx-click="show_account_dropdown"
          phx-target={@myself}
        >
          <.icon name="hero-user-solid" class="h-5 w-5" />
        </button>
        <!-- Dropdown menu -->
        <div
          :if={@show_account_dropdown}
          class="dropdown-menu space-y-2 absolute bottom-full left-0 group-hover:block border-2 rounded-md shadow-sm-brutal border-gray-900 py-4 bg-white w-48 px-4 mb-2"
          phx-click-away="close-account-dropdown"
          phx-target={@myself}
        >
          <%= for {label, icon, phx_click} <- [{"Profile", "hero-user", "goto-profile"}, {"Logout", "hero-arrow-right-start-on-rectangle", "goto-logout"}] do %>
            <.account_dropdown_item label={label} icon={icon} phx_click={phx_click} myself={@myself} />
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
