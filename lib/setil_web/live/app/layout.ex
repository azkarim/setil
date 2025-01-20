defmodule SetilWeb.App.Layout do
  use SetilWeb, :html
  alias SetilWeb.App.Components.SidebarComponent

  # @impl true
  def render(assigns) do
    ~H"""
    <main class="bg-gray-50 min-h-screen min-w-screen flex">
      <.flash_group flash={@flash} />
      <div class="w-16 border flex items-end justify-center h-screen fixed">
        <.live_component module={SidebarComponent} id="sidebar" />
      </div>
      <div class="ml-16 px-12 py-12 w-full">
        <%= @inner_content %>
      </div>
    </main>
    """
  end
end
