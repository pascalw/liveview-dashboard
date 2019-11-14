defmodule DashboardWeb.Job do
  defmacro __using__(namespace: namespace) do
    quote do
      use GenServer

      def start_link(opts) do
        GenServer.start_link(__MODULE__, opts)
      end
      defoverridable start_link: 1

      def init(opts) do
        {:ok, opts}
      end
      defoverridable init: 1

      defp broadcast(message) do
        Phoenix.PubSub.broadcast(Dashboard.PubSub, "events", {unquote(namespace), message})
      end
    end
  end
end
