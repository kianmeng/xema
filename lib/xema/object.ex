defmodule Xema.Object do
  @behaviour Xema

  def properties(_), do: nil

  def is_valid?(_, _), do: false
end
