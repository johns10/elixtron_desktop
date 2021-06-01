defmodule ElixtronDesktop.Application do
  use Application

  def start(_type, _args) do
    children = [ ElixtronDesktop.Server ]
    opts = [strategy: :one_for_one, name: __MODULE__.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
