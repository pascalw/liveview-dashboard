defmodule Dashboard.EventHistory do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def fetch_last_event(event_id) do
    GenServer.call(__MODULE__, {:fetch_last_event, event_id})
  end

  def store(event_id, message) do
    GenServer.cast(__MODULE__, {:store, event_id, message})
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:store, event_id, event}, state) do
    state = Map.put(state, event_id, event)
    {:noreply, state}
  end

  @impl true
  def handle_call({:fetch_last_event, event_id}, _from, state) do
    {:reply, Map.get(state, event_id), state}
  end
end
