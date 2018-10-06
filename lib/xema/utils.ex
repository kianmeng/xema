defmodule Xema.Utils do
  @moduledoc false

  alias Xema.Mapz

  @spec default(any, any) :: any
  def default(nil, b), do: b
  def default(a, _b), do: a

  @spec to_existing_atom(String.t()) :: atom | nil
  def to_existing_atom(str) do
    String.to_existing_atom(str)
  rescue
    _ -> nil
  end

  @spec has_key?(map | keyword | list, any) :: boolean
  def has_key?([], _), do: false

  def has_key?(map, key) when is_map(map), do: Mapz.has_key?(map, key)

  def has_key?(list, key) when is_list(list) do
    case Keyword.keyword?(list) do
      true -> Keyword.has_key?(list, key)
      false -> Enum.any?(list, fn {k, _} -> k == key end)
    end
  end

  @spec update_id(map, binary) :: map
  def update_id(%{id: a} = map, b) do
    Map.put(map, :id, update_uri(a, b))
  end

  @spec update_uri(URI.t() | nil, URI.t() | nil) :: URI.t() | nil
  def update_uri(nil, nil), do: nil

  def update_uri(id, nil), do: URI.parse(id)

  def update_uri(nil, id), do: URI.parse(id)

  def update_uri(old, new), do: old |> URI.merge(new)

  @spec size(map | list | tuple) :: integer
  def size(list) when is_list(list), do: length(list)

  def size(tuple) when is_tuple(tuple), do: tuple_size(tuple)
end
