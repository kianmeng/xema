defmodule Xema.Any do
  @moduledoc """
  TODO
  """

  use Xema.Validator.Enum

  @behaviour Xema

  defstruct [:enum]

  @spec keywords(keyword) :: %Xema.Any{}
  def keywords(keywords), do: struct(%Xema.Any{}, keywords)

  @spec is_valid?(%Xema{}, any) :: boolean
  def is_valid?(schema, value), do: validate(schema, value) == :ok

  @spec validate(%Xema{}, any) :: :ok | {:error, any}
  def validate(%Xema{keywords: keywords}, value) do
    with :ok <- enum(keywords, value),
      do: :ok
  end
end
