defmodule App.Bar.BarGenServer do
  use GenServer

  # Client API

  @doc """
  Starts the GenServer.
  """
  def start_link([]) do
    now = DateTime.utc_now()
    IO.puts("starting bar")

    initial_state = %{
      "Negroni" => %App.Bar.Drinks{
        name: "Negroni",
        price: 10.00,
        creation_date_time: now,
        count: 0
      },
      "Mojito" => %App.Bar.Drinks{
        name: "Mojito",
        price: 10.00,
        creation_date_time: now,
        count: 0
      },
      "Whisky Sour" => %App.Bar.Drinks{
        name: "Whisky Sour",
        price: 10.00,
        creation_date_time: now,
        count: 0
      },
      "Gin Tonic" => %App.Bar.Drinks{
        name: "Gin Tonic",
        price: 10.00,
        creation_date_time: now,
        count: 0
      }
    }

    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  @doc """
  Adds a new cocktail with its price.
  """
  def add_cocktail(name, price) do
    GenServer.call(__MODULE__, {:add_cocktail, name, price})
  end

  @doc """
  Gets the price of a specified cocktail.
  """
  def get_cocktail_price(name) do
    GenServer.call(__MODULE__, {:get_cocktail_price, name})
  end

  def get_cocktails() do
    GenServer.call(__MODULE__, {:get_cocktails})
  end

  def buy_cocktail(name) do
    GenServer.call(__MODULE__, {:buy_cocktail, name})
  end

  @impl true
  def init(initial_state) do
    # The initial state is an empty map or provided initial state
    schedule_print()
    {:ok, initial_state}
  end

  defp schedule_print do
    # 3 seconds
    Process.send_after(self(), :print_graph, 3_000)
  end

  @impl true
  def handle_info(:print_graph, state) do
    print_graph(state)
    # Reschedule the next print
    schedule_print()
    {:noreply, state}
  end

  defp print_graph(state) do
    IO.write([IO.ANSI.clear(), IO.ANSI.home()])
    IO.puts("\nCocktail Purchases:")

    Enum.each(state, fn {name, %App.Bar.Drinks{count: count, price: price}} ->
      IO.puts("#{name}: " <> String.duplicate("*", count) <> " #{price}")
    end)
  end

  @impl true
  def handle_call({:add_cocktail, name, price}, _from, state) do
    # Update the state with the new cocktail price
    new_state =
      Map.put(state, name, %App.Bar.Drinks{
        name: name,
        price: price,
        creation_date_time: DateTime.utc_now(),
        last_bought_date_time: nil,
        count: 0
      })

    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:get_cocktail_price, name}, _from, state) do
    # Retrieve the price of the cocktail
    cocktail = Map.get(state, name, :not_found)
    {:reply, cocktail, state}
  end

  @impl true
  def handle_call({:get_cocktails}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:buy_cocktail, name}, _from, state) do
    # retrieve a cocktail
    cocktail = Map.get(state, name, :not_found)

    new_state =
      Enum.map(state, fn {key, element} -> update(name, {key, element}) end)
      |> Enum.into(%{})

    {:reply, cocktail, new_state}
  end

  defp update(
         target_name,
         {name,
          %App.Bar.Drinks{price: price, creation_date_time: _creation_date, count: count} = drink}
       )
       when target_name == name do
    {name,
     %App.Bar.Drinks{
       drink
       | last_bought_date_time: DateTime.utc_now(),
         price: price + 0.01,
         count: count + 1
     }}
  end

  defp update(
         _target_name,
         {name,
          %App.Bar.Drinks{
            price: price,
            creation_date_time: _creation_date,
            last_bought_date_time: last_bought
          } = cocktail}
       )
       when not is_nil(last_bought) do
    if DateTime.diff(last_bought, DateTime.utc_now(), :second) < -10 do
      {name, %App.Bar.Drinks{cocktail | price: price - 0.01}}
    else
      {name, cocktail}
    end
  end

  defp update(
         _target_name,
         {name, %App.Bar.Drinks{price: price, creation_date_time: creation_date} = cocktail}
       ) do
    if DateTime.diff(creation_date, DateTime.utc_now(), :second) < -30 do
      {name, %App.Bar.Drinks{cocktail | price: price - 0.10}}
    else
      {name, cocktail}
    end
  end
end
