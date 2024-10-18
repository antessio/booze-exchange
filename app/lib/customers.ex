defmodule App.Customers do
  use GenServer

  # Client API
  def start_link(name) do
    IO.puts("starting customer #{name}")
    GenServer.start_link(__MODULE__, %{name: name}, name: name)
  end

  # Server Callbacks
  @impl true
  def init(state) do
    schedule_cocktail_purchase()
    {:ok, state}
  end

  @impl true
  def handle_info(:buy_cocktail, state) do
    cocktail =
      App.Bar.get_cocktails()
      |> IO.inspect(label: "updated list of cocktails")
      |> Map.keys()
      |> Enum.random()

    App.Bar.buy_cocktail(cocktail)
    IO.puts("customer #{state.name} bought #{cocktail}")
    schedule_cocktail_purchase()
    {:noreply, state}
  end

  defp schedule_cocktail_purchase() do
    # Random interval between 1 and 5 seconds
    interval = :rand.uniform(65_000)
    Process.send_after(self(), :buy_cocktail, interval)
  end
end
