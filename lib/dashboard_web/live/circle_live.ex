defmodule DashboardWeb.CircleCI do
  defmodule Widget do
    use Dashboard.Widget

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
    use Dashboard.TimedJob, refresh_interval: 10_000

    @headers [Accept: "application/json"]

    def handle_info(:update, [opts: [event_id: event_id, project: project]] = state) do
      json =
        HTTPoison.get!(
          "https://circleci.com/api/v1.1/project/#{project}?filter=completed&limit=1",
          @headers
        ).body
        |> Jason.decode!()
        |> Enum.at(0)

      event = %{
        repo: json["reponame"],
        outcome: json["outcome"],
        buildUrl: json["build_url"]
      }

      broadcast(event_id, event)

      {:noreply, state}
    end
  end
end
