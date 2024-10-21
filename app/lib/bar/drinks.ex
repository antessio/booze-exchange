defmodule App.Bar.Drinks do
  use TypedStruct

  typedstruct do
    field(:name, String.t(), enforce: true)
    field(:creation_date_time, DateTime.t(), enforce: true)
    field(:price, float(), enforce: true)
    field(:last_bought_date_time, DateTime.t(), enforce: false)
    field(:count, integer(), enforce: true)
  end
end

defmodule App.Bar.Drinks.History do
  use TypedStruct

  typedstruct do
    field(:drink, String.t(), enforce: true)
    field(:customer, String.t(), enforce: true)
    field(:purchase_date, DateTime.t(), enforce: true)
  end
end
