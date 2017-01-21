defmodule Server.MessageController do
  use Server.Web, :controller
  alias Server.RedixPool, as: Redix
  import Server.Helpers, only: [ok!: 1]

  def index(conn, params) do
    json conn, %{messages: messages}
  end

  defp messages do
    message_ids
    |> message_list
  end

  defp message_ids do
    Redix.command(~w(ZREVRANGEBYSCORE room:lobby +inf -inf limit 0 20)) |> ok!
  end

  defp message_list([] = _message_ids), do: []
  defp message_list(message_ids) do
    message_ids
    |> Enum.map(&(~w(HGETALL message:#{&1})))
    |> Redix.pipeline
    |> ok!
    |> Enum.map(&chunk_by_key_value(&1) |> new_map_from_chunks)
  end

  defp chunk_by_key_value(enum) when is_list(enum) and length(enum) < 2, do: []
  defp chunk_by_key_value(enum) when is_list(enum) and length(enum) >= 2 do
    Enum.chunk(enum, 2)
  end

  defp new_map_from_chunks(chunks) when is_list(chunks) and length(chunks) == 0, do: %{}
  defp new_map_from_chunks(chunks) when is_list(chunks) do
    Enum.reduce(chunks, %{}, fn ([key, val], acc) -> Map.put(acc, String.to_atom(key), val) end)
  end
end
