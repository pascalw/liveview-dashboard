defmodule DashboardWeb.Widget do
  @default_opts [class: "widget flex-layout__widget"]

  defmacro __using__(opts) do
    style = Keyword.get(opts, :style, [])

    opts =
      @default_opts
      |> Keyword.merge(opts)
      |> Keyword.put(:style, to_css(style))

    quote do
      use Phoenix.LiveView, container: {:div, unquote(opts)}
    end
  end

  defp to_css(kw_list) do
    Enum.map_join(kw_list, ";", fn {key, val} -> ~s{#{key}: #{val}} end)
  end
end
