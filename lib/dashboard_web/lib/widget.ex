defmodule DashboardWeb.Widget do
  @default_opts [class: "widget__wrapper flex-layout__widget"]

  defmacro __using__([namespace: namespace] = opts) do
    style = Keyword.get(opts, :style, [])

    opts =
      @default_opts
      |> Keyword.merge(opts)
      |> Keyword.put(:style, to_css(style))
      |> Keyword.delete(:namespace)

    quote do
      use Phoenix.LiveView, container: {:div, unquote(opts)}

      defp static_path(path) do
        DashboardWeb.Endpoint.static_path(path)
      end

      defp subscribe(socket) do
        Phoenix.PubSub.subscribe(Dashboard.PubSub, "events")

        case DashboardWeb.History.history(unquote(namespace)) |> IO.inspect(label: "history") do
          nil -> {:ok, socket}
          event ->
            {:noreply, socket} = handle_info({unquote(namespace), event}, socket)
            {:ok, socket}
        end
      end

      def handle_info({unquote(namespace), event}, socket) do
        handle_info(event, socket)
      end
    end
  end

  defp to_css(kw_list) do
    Enum.map_join(kw_list, ";", fn {key, val} -> ~s{#{key}: #{val}} end)
  end
end
