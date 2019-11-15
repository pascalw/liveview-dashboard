defmodule Dashboard.EventHistory do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def fetch_last_event(namespace) do
    GenServer.call(__MODULE__, {:fetch_last_event, namespace})
  end

  @impl true
  def init(_opts) do
    Phoenix.PubSub.subscribe(Dashboard.PubSub, "events")
    {:ok, %{}}
  end

  @impl true
  def handle_info({namespace, event}, state) do
    state = Map.put(state, namespace, event)
    {:noreply, state}
  end

  @impl true
  def handle_call({:fetch_last_event, namespace}, _from, state) do
    {:reply, Map.get(state, namespace), state}
  end
end
