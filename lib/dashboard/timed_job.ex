defmodule Dashboard.TimedJob do
  defmacro __using__(refresh_interval: refresh_interval) do
    quote do
      use Dashboard.Job

      def init(opts) do
        send(self(), :update)
        :timer.send_interval(unquote(refresh_interval), self(), :update)

        {:ok, opts}
      end
    end
  end
end
