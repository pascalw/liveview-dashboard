defmodule Dashboard.Widget do
  defmacro __using__(opts) do
    style = Keyword.get(opts, :style, [])

    opts =
      [class: "widget__wrapper flex-layout__widget"]
      |> Keyword.merge(opts)
      |> Keyword.put(:style, to_css(style))

    quote do
      use Phoenix.LiveView, container: {:div, unquote(opts)}
      @before_compile Dashboard.Widget

      def mount(options, socket) do
        if connected?(socket) && Map.has_key?(options, :event_id) do
          subscribe(socket, Map.get(options, :event_id))
        else
          {:ok, socket}
        end
      end
      defoverridable mount: 2

      def handle_info({_event_id, event}, socket) do
        handle_info(event, socket)
      end

      defp static_path(path) do
        DashboardWeb.Endpoint.static_path(path)
      end

      defp subscribe(socket, event_id) do
        Phoenix.PubSub.subscribe(Dashboard.PubSub, event_id)

        with event when not is_nil(event) <-
               Dashboard.EventHistory.fetch_last_event(event_id),
             {_, socket} <- handle_info({event_id, event}, socket) do
          {:ok, socket}
        else
          _ -> {:ok, socket}
        end
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      @doc """
      Provides a default implementation that exposes every field
      on events to the LiveView Socket.

      For example the following event broadcasted from the job:

      ```ex
        broadcast(%{
          repo: "phoenix_live_view",
          outcome: "success"
        })
      ```

      Will result in `repo` and `outcome` to be assigned on the LiveView socket.

      ```ex
        def render(%{repo: _} = assigns) do
          ~L\"\"\"
          <div class="widget" style="background-color: <%= bg_color(@outcome) %>">
            <span class="widget__label-large" style="margin-top: 10px;"><%= @repo %></span>
            <span class="widget__label-medium"><%= @outcome %></span>
            <div class="widget__bg-image" style="background-image: url(<%= static_path("/images/circleci.svg") %>)"></div>
          </div>
          \"\"\"
        end
      ```

      If this is undesirable simply define handle_info/2 yourself in your Widget.
      """
      def handle_info(event, socket) do
        socket =
          Enum.reduce(event, socket, fn {key, value}, socket ->
            assign(socket, key, value)
          end)

        {:noreply, socket}
      end
    end
  end

  defp to_css(kw_list) do
    Enum.map_join(kw_list, ";", fn {key, val} -> ~s{#{key}: #{val}} end)
  end
end
