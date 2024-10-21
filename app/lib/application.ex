# lib/my_app/application.ex

defmodule App.Application do
  use Application

  def start(_type, _args) do
    children = [
      Supervisor.child_spec(App.Bar.BarGenServer, id: :bar),
      Supervisor.child_spec({App.Customers.CustomerGenServer, :antessio}, id: :antessio),
      Supervisor.child_spec({App.Customers.CustomerGenServer, :mammt}, id: :mammt),
      Supervisor.child_spec({App.Customers.CustomerGenServer, :bud_spencer}, id: :bud_spencer),
      Supervisor.child_spec({App.Customers.CustomerGenServer, :terence_hill}, id: :terence_hill)
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
