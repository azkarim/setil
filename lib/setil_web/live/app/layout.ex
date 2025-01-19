defmodule SetilWeb.App.Layout do
  use SetilWeb, :html
  use SetilWeb, :live_view
  alias SetilWeb.App.Components.SidebarComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="[scrollbar-gutter:stable]">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <meta
          name="description"
          content="SETIL - Practice platform for TOEFL, IELTS, and English proficiency tests. Improve your English skills with our innovative learning tools."
        />
        <meta
          name="keywords"
          content="TOEFL, IELTS, English practice, Mock exams, language learning, English proficiency test"
        />
        <meta name="author" content="SETIL" />
        <!-- Open Graph metadata for social sharing -->
        <meta property="og:title" content={assigns[:page_title] || "SETIL"} />
        <meta
          property="og:description"
          content="Practice platform for TOEFL, IELTS, and English proficiency tests. Improve your English skills with our innovative learning tools."
        />
        <meta property="og:type" content="website" />
        <!-- Title -->
        <.live_title suffix=" · SETIL">
          <%= assigns[:page_title] || "SETIL" %>
        </.live_title>
        <!-- Styles and Scripts -->
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
        </script>
        <script
          defer
          src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.3/dist/confetti.browser.min.js"
        >
        </script>
      </head>
      <body class="font-mono antialiased">
        <div class="bg-gray-50 min-h-screen min-w-screen flex">
          <.flash_group flash={@flash} />
          <div class="w-16 border flex items-end justify-center h-screen fixed">
            <.live_component module={SidebarComponent} id="sidebar" />
          </div>
          <div class="ml-16 px-12 py-12 w-full">
            <%= @inner_content %>
          </div>
        </div>
      </body>
    </html>
    """
  end
end
