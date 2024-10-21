defmodule App.Customers.CustomerGenServer do
  use GenServer

  # Client API
  def start_link(name) do
    IO.puts("starting customer #{name}")
    GenServer.start_link(__MODULE__, %App.Customers.Customers{name: name, drinks: []}, name: name)
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
      App.Bar.BarGenServer.get_cocktails()
      # |> IO.inspect(
      #   label: IO.ANSI.format([:blue, "updated list"]),
      #   syntax_colors: [atom: :red, string: :green]
      # )
      |> Map.keys()
      |> Enum.random()

    App.Bar.BarGenServer.buy_cocktail(cocktail)
    #IO.puts(IO.ANSI.format([:yellow, "customer #{state.name} bought #{cocktail}"]))
    update_state = update(state, cocktail)
    schedule_cocktail_purchase()

    #IO.inspect(update_state, label: IO.ANSI.format([:blue, "customers"]), syntax_colors: [atom: :red, string: :green])
    {:noreply, update_state}
  end

  defp update(%{name: _name, drinks: drinks} = customer, drink) do
    %App.Customers.Customers{customer | drinks: [drink | drinks]}
  end

  defp schedule_cocktail_purchase() do
    interval = :rand.uniform(25_000)
    Process.send_after(self(), :buy_cocktail, interval)
  end
end
