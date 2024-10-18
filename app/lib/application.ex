# lib/my_app/application.ex

defmodule App.Application do
  use Application

  def start(_type, _args) do
    children = [
      Supervisor.child_spec(App.Bar, id: :bar),
      Supervisor.child_spec({App.Customers, :antessio}, id: :antessio),
      Supervisor.child_spec({App.Customers, :mammt}, id: :mammt),
      Supervisor.child_spec({App.Customers, :bud_spencer}, id: :bud_spencer),
      Supervisor.child_spec({App.Customers, :terence_hill}, id: :terence_hill)
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
