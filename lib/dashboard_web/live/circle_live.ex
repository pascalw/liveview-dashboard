defmodule DashboardWeb.CircleCI do
  defmodule Widget do
    use Dashboard.Widget, namespace: "circleci"

    def render(%{repo: _} = assigns) do
      ~L"""
      <div class="widget" style="background-color: <%= bg_color(@outcome) %>">
        <span class="widget__label-large" style="margin-top: 10px;"><%= @repo %></span>
        <span class="widget__label-medium"><%= @outcome %></span>
        <div class="widget__bg-image" style="background-image: url(<%= static_path("/images/circleci.svg") %>)"></div>
      </div>
      """
    end

    def render(assigns), do: ~L""

    defp bg_color("success"), do: "#429c6a"
    defp bg_color(_), do: "#dd1506"
  end

  defmodule Job do
    use Dashboard.Job, namespace: "circleci"
    @refresh_interval 10000

    def init(_) do
      send(self(), :update)
      :timer.send_interval(@refresh_interval, self(), :update)

      {:ok, nil}
    end

    def handle_info(:update, _state) do
      broadcast(%{
        repo: "Dashbling",
        outcome: Enum.random(["success", "fail"])
      })

      {:noreply, nil}
    end
  end
end
