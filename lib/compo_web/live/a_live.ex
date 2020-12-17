defmodule CompoWeb.ALive do
  use CompoWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <main>
      <section>
        <dl>
          <dt>socket.root_pid:</dt>
          <dd><b><%= inspect(@socket.root_pid || "") %></b></dd>
          <dt>Process.info(socket.root_pid, :memory):</dt>
          <dd><b><%= @mem %></b></dd>
        </dl>
      </section>
      <section style="disp">
        <button phx-click="page" phx-value-page="light"
          style="<%= if @page == ~s(light), do: 'border: 4px solid black; box-sizing: content-box' %>">Light page</button>
        <button phx-click="page" phx-value-page="heavy"
          style="<%= if @page == ~s(heavy), do: 'border: 4px solid black; box-sizing: content-box' %>">Heavy page</button>
        <button phx-click="crash" style="background-color: red">Crash it</button>

        <%= if @page == "light" do %>
          <div>Light content (no components)</div>
        <% else %>
          <div>
            <p>Memory is double (lv assigns + components assigns) as the following code runs:</p>
            <pre><%= @code %></pre>
            <%= for n <- 1..1000 do %>
              <%= live_component(@socket, CompoWeb.ComponentA, id: n, data: @data) %>
            <% end %>
          </div>
        <% end %>
      </section>
    </main>

    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      if connected?(socket) do
        send(self(), :tick)
        assign(socket, :mem, mem_str(socket))
      else
        assign(socket, :mem, "-")
      end

    data = List.duplicate(%{"<p>Donec congue lacinia dui, Sed nec diam.</p>" => true}, 100_000)
    socket = assign(socket, :page, "light")
    socket = assign(socket, :code, code())
    socket = assign(socket, :data, data)

    {:ok, socket}
  end

  @impl true
  def handle_event("page", %{"page" => p}, socket) do
    {:noreply, assign(socket, :page, p)}
  end

  @impl true
  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    socket = assign(socket, :mem, mem_str(socket))
    {:noreply, socket}
  end

  defp mem_str(socket) do
    {:memory, mem} = Process.info(socket.root_pid, :memory)
    "#{mem / (1024 * 1024)} MB"
  end

  defp code() do
    """
    <%= for n <- 1..1000 do %>
      <%= live_component(@socket, CompoWeb.ComponentA, id: n, data: @data) %>
    <% end %>
    """
  end
end
