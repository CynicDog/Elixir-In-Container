defmodule ContainerizedElixir.GreetInHttp do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  def child_spec(_arg) do
    Plug.Cowboy.child_spec(
      scheme: :http,
      options: [port: 8080],
      plug: __MODULE__
    )
  end

  get "/greet" do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "🚀 Elixir inside a container — greetings from the BEAM!")
  end
end