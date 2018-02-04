defmodule Xema.Base do
  defmacro __using__(_opts) do
    quote do
      @behaviour Xema.Base
      # def hello(name), do: "Hi, #{name}"
      alias Xema.Base

      @enforce_keys [:content]

      @type t :: %__MODULE__{
        content: Xema.Schema.t(),
      }

      defstruct [
        :content,
      ]

      def create(schema), do: struct(__MODULE__, content: schema)
    end
  end

  @callback is_valid?(Struct, any) :: Boolean
end
