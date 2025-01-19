defmodule SetilWeb.Users.LoginLive do
  use SetilWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl min-h-screen px-4 py-8 sm:px-6 lg:px-8 flex flex-col">
      <div class="w-full font-mono">
        <.link
          href={~p"/"}
          class="w-max mx-auto py-4 md:py-0 md:mx-0 text-4xl md:text-2xl font-mono font-bold text-zinc-900"
          aria-label="SETIL Home"
        >
          SETIL
        </.link>
      </div>
      <div class="flex-1 flex items-center justify-center">
        <div class="w-full max-w-5xl grid grid-cols-1 md:grid-cols-2 overflow-hidden rounded-2xl border-4 border-black bg-white shadow-lg-brutal">
          <div class="flex items-center justify-center bg-indigo-400 p-6">
            <div class="relative h-64 w-64">
              <div class="absolute left-0 top-0 h-32 w-24 bg-[#FF7E54] shadow-brutal"></div>
              <div class="absolute left-20 top-8 h-32 w-24 bg-black shadow-brutal"></div>
              <div class="absolute bottom-0 left-10 h-32 w-32 rounded-full bg-[#FFE156] shadow-brutal">
              </div>
            </div>
          </div>
          <div class="flex flex-col justify-center p-8">
            <.header>
              <span class="text-4xl font-black">Welcome back!</span>
              <:subtitle>
                Don't have an account?
                <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
                  <span class="underline">Sign up</span>
                </.link>
              </:subtitle>
            </.header>

            <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
              <.input field={@form[:email]} type="email" label="Email" required />
              <.input field={@form[:password]} type="password" label="Password" required />

              <:actions>
                <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
                <.link href={~p"/users/reset_password"} class="text-sm font-semibold underline">
                  Forgot your password?
                </.link>
              </:actions>
              <:actions>
                <.button phx-disable-with="Logging in..." class="w-full">
                  Log in <span aria-hidden="true">→</span>
                </.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
