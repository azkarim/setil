defmodule SetilWeb.App.Components.SidebarComponent do
  use SetilWeb, :html
  alias Phoenix.LiveView.JS

  def sidebar(assigns) do
    ~H"""
    <div class="w-16 h-full py-12 flex flex-col items-center justify-between">
      <div>
        <.link
          navigate={~p"/app/"}
          class="h-10 w-10 bg-white rounded-full border-2 border-gray-900 flex items-center justify-center hover:-translate-y-0.5 transition-transform cursor-pointer shadow-sm-brutal"
        >
          <.icon name="hero-home-solid" class="h-5 w-5" />
        </.link>
      </div>
      <div class="relative group">
        <button
          class="h-10 w-10 bg-white rounded-full border-2 border-gray-900 flex items-center justify-center hover:-translate-y-0.5 transition-transform cursor-pointer shadow-sm-brutal"
          phx-click={toggle_account_dropdown_menu()}
        >
          <.icon name="hero-user-solid" class="h-5 w-5" />
        </button>
        <!-- BEGIN : Dropdown menu -->
        <div
          class="dropdown-menu space-y-2 absolute bottom-full left-0 border-2 rounded-md shadow-sm-brutal border-gray-900 py-4 bg-white w-48 px-4 mb-2"
          phx-click-away={toggle_account_dropdown_menu()}
          id="account_dropdown_menu"
          hidden="true"
        >
          <.link navigate={~p"/app/settings"} class="account-menu-item">
            <.icon name="hero-user" class="h-5 w-5" />
            <span>Profile</span>
          </.link>

          <.link href={~p"/users/log_out"} method="delete" class="account-menu-item">
            <.icon name="hero-arrow-right-start-on-rectangle" class="h-5 w-5" />
            <span>Sign out</span>
          </.link>
        </div>
        <!-- END : Dropdown menu -->
      </div>
    </div>
    """
  end

  defp toggle_account_dropdown_menu do
    JS.toggle(to: "#account_dropdown_menu")
  end
end
