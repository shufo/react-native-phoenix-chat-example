defmodule Server.Helpers do
  def ok!(param) do
    case param do
      {:ok, value} -> value
      {:error, error} -> raise error
      _ = value -> value
    end
  end
end
