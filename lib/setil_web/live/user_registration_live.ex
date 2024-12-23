defmodule SetilWeb.UserRegistrationLive do
  use SetilWeb, :live_view

  alias Setil.Accounts
  alias Setil.Accounts.User

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
              <span class="text-4xl font-black">Register an account</span>
              <:subtitle>
                Already registered?
                <.link navigate={~p"/app/users/log_in"} class="font-semibold text-brand">
                  <span class="underline">Log in</span>
                </.link>
                to your account now.
              </:subtitle>
            </.header>

            <.simple_form
              for={@form}
              id="registration_form"
              phx-submit="save"
              phx-change="validate"
              phx-trigger-action={@trigger_submit}
              action={~p"/app/users/log_in?_action=registered"}
              method="post"
            >
              <.error :if={@check_errors}>
                Oops, something went wrong! Please check the errors below.
              </.error>

              <.input field={@form[:preferred_name]} type="text" label="Preferred Name" />

              <.input field={@form[:email]} type="email" label="Email" required />
              <.input field={@form[:password]} type="password" label="Password" required />

              <:actions>
                <.button phx-disable-with="Creating account..." class="w-full">
                  Create an account
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
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/app/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
