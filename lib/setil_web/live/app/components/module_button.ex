defmodule SetilWeb.App.Components.ModuleButton do
  use SetilWeb, :html

  attr :label, :string, required: true
  attr :class, :string, default: ""
  attr :rest, :global

  def module_button(assigns) do
    ~H"""
    <button
      class={[
        @class,
        "h-20 px-4 py-2 text-sm bg-white border-2 font-bold border-black shadow-[4px_4px_0_0_rgba(0,0,0,1)] hover:shadow-[2px_2px_0_0_rgba(0,0,0,1)] hover:translate-x-[2px] hover:translate-y-[2px] disabled:opacity-50 disabled:pointer-events-none"
      ]}
      ,
    >
      <%= @label %>
    </button>
    """
  end
end
