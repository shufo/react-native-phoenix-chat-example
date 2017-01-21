defmodule RoomChannelTest do
  use Server.ChannelCase

  setup %{} do
    {:ok, _, socket} = socket("user:id", %{})
                        |> subscribe_and_join(Server.RoomChannel, "rooms:lobby", %{})
    {:ok, socket: socket}
  end

  test "send message", %{socket: socket} do
    push socket, "new:msg", %{"user" => "test", "body" => "foobar"}
    assert_broadcast "new:msg", %{user: "test", body: "foobar"}
  end
end
