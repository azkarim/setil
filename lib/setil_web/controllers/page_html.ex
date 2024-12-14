defmodule SetilWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use SetilWeb, :html
  use Phoenix.Component

  embed_templates "page_html/*"

  attr :title, :string, required: true
  attr :status, :string, required: true

  def feature_card(assigns) do
    assigns = assign(assigns, :is_available, assigns.status == "Available Now")

    ~H"""
    <div class={[
      "p-6 border-4 border-black shadow-brutal select-none cursor-default",
      (@is_available && "bg-white") || "bg-blue-50",
      "transform hover:-translate-y-1 transition-transform"
    ]}>
      <h3 class="font-mono font-bold text-xl mb-3"><%= @title %></h3>
      <p class={[
        "font-mono text-sm",
        (@is_available && "text-blue-600") || "text-blue-400"
      ]}>
        <%= @status %>
      </p>
    </div>
    """
  end

  def features do
    [
      %{
        title: "Match Heading with Passage",
        status: "Available Now"
      },
      %{
        title: "Multiple Choice Questions",
        status: "Coming Soon"
      },
      %{
        title: "True/False/Not Given",
        status: "Coming Soon"
      },
      %{
        title: "Fill in the Blanks",
        status: "Coming Soon"
      },
      %{
        title: "Sentence Completion",
        status: "Coming Soon"
      },
      %{
        title: "Summary Writing",
        status: "Coming Soon"
      }
    ]
  end
end
