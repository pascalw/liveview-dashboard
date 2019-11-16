defmodule Dashboard.Job do
  defmacro __using__(_) do
    quote do
      use GenServer

      def start_link(opts) do
        GenServer.start_link(__MODULE__, opts: opts)
      end
      defoverridable start_link: 1

      def init(opts) do
        {:ok, opts}
      end
      defoverridable init: 1

      defp broadcast(event_id, message) do
        Phoenix.PubSub.broadcast(Dashboard.PubSub, event_id, {event_id, message})
        Dashboard.EventHistory.store(event_id, message)
      end
    end
  end
end
