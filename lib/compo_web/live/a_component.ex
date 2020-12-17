defmodule CompoWeb.ComponentA do
  use CompoWeb, :live_component

  @impl true
  def render(assigns), do: ~L"."
end
