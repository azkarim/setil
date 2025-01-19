defmodule SetilWeb.Router do
  alias SetilWeb.App.Layout
  use SetilWeb, :router

  import SetilWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SetilWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SetilWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/app", SetilWeb.App do
    pipe_through [:browser, :require_authenticated_user]

    live_session :app,
      layout: {Layout, :render},
      on_mount: [{SetilWeb.UserAuth, :ensure_authenticated}] do
      live "/", HomeLive

      scope "/reading", Reading do
        live "/match-heading", MatchHeadingLive
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SetilWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:setil, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SetilWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/users", SetilWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SetilWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/register", Users.RegistrationLive, :new
      live "/log_in", Users.LoginLive, :new
      live "/reset_password", Users.ForgotPasswordLive, :new
      live "/reset_password/:token", Users.ResetPasswordLive, :edit
    end

    post "/log_in", UserSessionController, :create
  end

  scope "/app", SetilWeb.App do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SetilWeb.UserAuth, :ensure_authenticated}] do
      live "/settings", SettingsLive, :edit
      live "/settings/confirm_email/:token", SettingsLive, :confirm_email
    end
  end

  scope "/users", SetilWeb do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{SetilWeb.UserAuth, :mount_current_user}] do
      live "/confirm/:token", Users.ConfirmationLive, :edit
      live "/confirm", Users.ConfirmationInstructionsLive, :new
    end
  end
end
