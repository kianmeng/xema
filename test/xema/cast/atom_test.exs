defmodule Xema.Cast.AtomTest do
  use ExUnit.Case, async: true

  alias Xema.CastError

  import Xema, only: [cast: 2, cast!: 2, validate: 2]

  @set [42, 1.0, [foo: 42], [42], %{}, {:tuple}]

  describe "cast/2 with a minimal integer schema" do
    setup do
      %{
        schema: Xema.new(:atom)
      }
    end

    test "from an atom", %{schema: schema} do
      data = :foo
      assert validate(schema, data) == :ok
      assert cast(schema, data) == {:ok, data}
    end

    test "from a string", %{schema: schema} do
      data = "foo"
      assert validate(schema, data) == {:error, %{type: :atom, value: "foo"}}
      assert cast(schema, data) == {:ok, :foo}
    end

    test "from an invalid string", %{schema: schema} do
      assert cast(schema, "xyz") ==
               {:error, %{path: [], to: :atom, value: "xyz"}}
    end

    test "from an invalid type", %{schema: schema} do
      Enum.each(@set, fn data ->
        assert cast(schema, data) ==
                 {:error, %{path: [], to: :atom, value: data}}
      end)
    end

    test "from a type without protocol implementation", %{schema: schema} do
      assert_raise(Protocol.UndefinedError, fn ->
        cast(schema, ~r/.*/)
      end)
    end
  end

  describe "cast!/2 with a minimal integer schema" do
    setup do
      %{
        schema: Xema.new(:atom)
      }
    end

    test "from an atom", %{schema: schema} do
      assert cast!(schema, :foo) == :foo
    end

    test "from a string", %{schema: schema} do
      assert cast!(schema, "foo") == :foo
    end

    test "from an invalid string", %{schema: schema} do
      msg = ~s|cannot cast "xyz" to :atom, the atom is unknown|

      assert_raise CastError, msg, fn ->
        cast!(schema, "xyz")
      end
    end

    test "from a type without protocol implementation", %{schema: schema} do
      assert_raise(Protocol.UndefinedError, fn ->
        cast!(schema, ~r/.*/)
      end)
    end

    test "from an invalid type", %{schema: schema} do
      Enum.each(@set, fn data -> assert_raise_cast_error(schema, data) end)
    end

    defp assert_raise_cast_error(schema, data) do
      msg = "cannot cast #{inspect(data)} to :atom"

      assert_raise CastError, msg, fn ->
        cast!(schema, data)
      end
    end
  end
end
