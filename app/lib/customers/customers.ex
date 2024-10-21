defmodule App.Customers.Customers do
  use TypedStruct

  @moduledoc """
  A struct representing a customer
  """

  @typedoc "A customer"
  typedstruct do
    field(:name, String.t(), enforce: true)
    field(:drinks, [Drink.t()])
  end

  defmodule Drink do

    typedstruct do
      field(:name, String.t(), enforce: true)
    end
  end
end
