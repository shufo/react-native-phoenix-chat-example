defmodule Server.RoomChannel do
  use Phoenix.Channel
  alias Server.RedixPool, as: Redix
  require Logger
  import Server.Helpers, only: [ok!: 1]

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic
  Possible Return Values
  `{:ok, socket}` to authorize subscription for channel for requested topic
  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("rooms:lobby", message, socket) do
    {:ok, socket}
  end

  def handle_in("new:msg", %{"user" => user, "body" => body} = payload, socket) do
    save_message(user, body)
    broadcast! socket, "new:msg", %{user: user, body: body}
    {:reply, {:ok, %{msg: body}}, assign(socket, :user, user)}
  end

  defp save_message(user, body, message_id \\ next_message_id, created_at \\ now) do
    Redix.command(~w(HMSET message:#{message_id}
      id #{message_id}
      user #{user}
      body #{body}
      created_at #{created_at}
    ))
    Redix.command(~w(ZADD room:lobby #{created_at} #{message_id}))
  end

  defp next_message_id do
    Redix.command(~w(INCR next_message_id)) |> ok!
  end

  defp now do
    :os.system_time(:seconds)
  end
end
