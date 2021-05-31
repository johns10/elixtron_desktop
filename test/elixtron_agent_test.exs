defmodule ElixtronAgentTest do
  use ExUnit.Case
  doctest ElixtronAgent

  test "greets the world" do
    assert ElixtronAgent.hello() == :world
  end
end
