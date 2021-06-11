defmodule Genicon.Crypto.Hash do
  alias Genicon.Domain.Icon
  defexception message: "Hash Error"

  @spec hash(binary) :: {:error, binary} | {:ok, Icon.t()}
  def hash(data) when is_binary(data) do
    try do
      h = hash!(data)
      {:ok, h}
    rescue
      _ -> {:error, "Hash error"}
    end
  end

  @spec hash!(binary) :: Genicon.Domain.Icon.t()
  def hash!(data) when is_binary(data) do
    hex = :crypto.hash(:md5, data) |> :binary.bin_to_list()
    %Icon{hex: hex}
  end
end
