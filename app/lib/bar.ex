defmodule App.Bar do
  use GenServer

  # Client API

  @doc """
  Starts the GenServer.
  """
  def start_link([]) do
    now = DateTime.utc_now()
    IO.puts("starting bar")
    initial_state = %{
      "Negroni" => %{
        price: 10.00,
        creation_date: now
      },
      "Mojito" => %{
        price: 10.00,
        creation_date: now
      },
      "Whisky Sour" => %{
        price: 10.00,
        creation_date: now
      },
      "Gin Tonic" => %{
        price: 10.00,
        creation_date: now
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
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:add_cocktail, name, price}, _from, state) do
    # Update the state with the new cocktail price
    new_state =
      Map.put(state, name, %{
        price: price,
        last_bought: nil
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

  defp update(target_name, {name, %{price: price, creation_date: creation_date}}) when target_name == name do
    {name, %{last_bought: DateTime.utc_now(), price: price + 0.01, creation_date: creation_date}}
  end

  defp update(
         _target_name,
         {name,
          %{price: price, creation_date: _creation_date, last_bought: last_bought} = cocktail}
       ) when not is_nil(last_bought) do
    if DateTime.diff(last_bought, DateTime.utc_now(), :second) < -10 do
      {name, %{cocktail | price: price - 0.01}}
    else
      {name, cocktail}
    end
  end

  defp update(
         _target_name,
         {name, %{price: price, creation_date: creation_date} = cocktail}
       ) do
    if DateTime.diff(creation_date, DateTime.utc_now(), :second) < -30 do
      {name, %{cocktail | price: price - 0.10}}
    else
      {name, cocktail}
    end
  end
end
