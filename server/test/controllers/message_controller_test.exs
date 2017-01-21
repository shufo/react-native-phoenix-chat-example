defmodule MessageControllerTest do
  use Server.ConnCase
  use Server.ChannelCase

  setup %{} do
    {:ok, _, socket} = socket("user:id", %{})
                        |> subscribe_and_join(Server.RoomChannel, "rooms:lobby", %{})
    {:ok, socket: socket}
  end

  test "get messages", %{socket: socket} do
    push socket, "new:msg", %{"user" => "test", "body" => "foobar"}
    assert_broadcast "new:msg", %{user: "test", body: "foobar"}

    conn = get build_conn(), "/messages", %{}
    body = json_response(conn, :ok)
    assert body["messages"] |> Enum.count > 0
  end
end
