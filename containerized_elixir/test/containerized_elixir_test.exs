defmodule ContainerizedElixirTest do
  use ExUnit.Case
  doctest ContainerizedElixir

  test "greets the world" do
    assert ContainerizedElixir.hello() == :world
  end
end
