defmodule SetilWeb.App.Components.RangeStepSlider do
  use SetilWeb, :html

  attr :class, :string, default: ""
  attr :id, :string
  attr :label, :string, default: "Range slider"
  attr :min, :integer, required: true
  attr :max, :integer, required: true
  attr :step, :integer, required: true
  attr :value, :integer, required: true
  attr :disabled, :boolean, default: false
  attr :phx_change, :string, default: nil

  def range_step_slider(assigns) do
    assigns = assign_new(assigns, :id, fn -> "range-#{System.unique_integer()}" end)

    ~H"""
    <div class="flex-1 space-y-2">
      <label for={@id} class={"flex justify-between pb-2 text-sm #{@disabled && "opacity-50"}"}>
        <%= @label %>
        <span><%= @value %></span>
      </label>
      <input
        phx-hook="RangeSlider"
        type="range"
        id={@id}
        name={@id}
        aria-orientation="horizontal"
        disabled={@disabled}
        min={@min}
        max={@max}
        step={@step}
        value={@value}
        phx-change={@phx_change}
        class="w-full h-[2px] bg-gray-200 rounded-lg appearance-none cursor-pointer disabled:opacity-50 transition-opacity duration-200
            [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:w-4 [&::-webkit-slider-thumb]:h-4
            [&::-webkit-slider-thumb]:bg-blue-500 [&::-webkit-slider-thumb]:rounded-full
            [&::-webkit-slider-thumb]:border-2 [&::-webkit-slider-thumb]:border-black
            [&::-webkit-slider-thumb]:shadow-[0_2px_0_0_rgba(0,0,0,1)] [&::-webkit-slider-thumb]:cursor-pointer
            [&::-moz-range-thumb]:w-4 [&::-moz-range-thumb]:h-4 [&::-moz-range-thumb]:bg-blue-500
            [&::-moz-range-thumb]:rounded-full [&::-moz-range-thumb]:border-2 [&::-moz-range-thumb]:border-black
            [&::-moz-range-thumb]:shadow-[0_2px_0_0_rgba(0,0,0,1)] [&::-moz-range-thumb]:cursor-pointer"
      />
    </div>
    """
  end
end
