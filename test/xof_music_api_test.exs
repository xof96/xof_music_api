defmodule XofMusicApiTest do
  use ExUnit.Case
  doctest XofMusicApi

  test "greets the world" do
    assert XofMusicApi.hello() == :world
  end
end
