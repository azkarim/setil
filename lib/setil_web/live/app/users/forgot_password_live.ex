defmodule SetilWeb.App.Users.ForgotPasswordLive do
  use SetilWeb, :live_view

  alias Setil.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl min-h-screen px-4 py-8 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-sm font-mono">
        <.link
          href={~p"/"}
          class="block w-max mx-auto py-4 md:py-0 md:mx-0 text-4xl md:text-2xl font-mono font-bold text-zinc-900 mb-12"
          aria-label="SETIL Home"
        >
          SETIL
        </.link>
        <div>
          <.header class="text-center">
            Forgot your password?
            <:subtitle>We'll send a password reset link to your inbox</:subtitle>
          </.header>

          <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
            <.input field={@form[:email]} type="email" placeholder="Email" required />
            <:actions>
              <.button phx-disable-with="Sending..." class="w-full">
                Send password reset instructions
              </.button>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/app/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
