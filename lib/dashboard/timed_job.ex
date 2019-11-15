defmodule Dashboard.TimedJob do
  defmacro __using__(namespace: namespace, refresh_interval: refresh_interval) do
    quote do
      use Dashboard.Job, namespace: unquote(namespace)

      def init(_) do
        send(self(), :update)
        :timer.send_interval(unquote(refresh_interval), self(), :update)

        {:ok, nil}
      end
    end
  end
end
