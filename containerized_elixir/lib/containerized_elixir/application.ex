defmodule ContainerizedElixir.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
       {ContainerizedElixir.GreetInHttp, []}
    ]

    opts = [strategy: :one_for_one, name: ContainerizedElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
