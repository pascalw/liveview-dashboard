defmodule DashboardWeb.ClockLive do
  use Phoenix.LiveView, container: {:div, class: "widget flex-layout__widget", style: "background-color: rgb(0, 134, 90)"}

  def mount(_, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_datetime(socket)}
  end

  def render(assigns) do
    ~L"""
    <span class="widget__label-medium"><%= date(@date_time) %></span>
    <span class="widget__label-large" style="margin-top: 10px;"><%= time(@date_time) %></span>
    """
  end

  def handle_info(:tick, socket) do
    {:noreply, put_datetime(socket)}
  end

  defp put_datetime(socket) do
    assign(socket, date_time: Timex.now("Europe/Amsterdam"))
  end

  defp time(date_time), do: Timex.format!(date_time, "{h24}:{m}")
  defp date(date_time), do: Timex.format!(date_time, "{WDshort} {Mshort} {0D} {YYYY}")
end
