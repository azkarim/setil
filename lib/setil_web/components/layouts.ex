defmodule SetilWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use SetilWeb, :controller` and
  `use SetilWeb, :live_view`.
  """
  use SetilWeb, :html

  embed_templates "layouts/*"

  def app_path?(conn) do
    String.starts_with?(conn.request_path, "/app")
  end

  def include_app_route_js(assigns) do
    path = assigns.conn.request_path

    if String.starts_with?(path, "/app/") do
      ~H"""
      <script
        defer
        src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.3/dist/confetti.browser.min.js"
      >
      </script>
      """
    else
      ~H""
    end
  end
end
