defmodule Suite.Draft4.AdditionalPropertiesTest do
  use ExUnit.Case, async: true

  import Xema, only: [is_valid?: 2]

  describe "additional_properties being false does not allow other properties" do
    setup do
      %{
        schema:
          Xema.new(
            :any,
            additional_properties: false,
            pattern_properties: %{"^v" => :any},
            properties: %{bar: :any, foo: :any}
          )
      }
    end

    @tag :draft4
    @tag :additional_properties
    test "no additional properties is valid", %{schema: schema} do
      data = %{foo: 1}
      assert is_valid?(schema, data)
    end

    @tag :draft4
    @tag :additional_properties
    test "an additional property is invalid", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: "boom"}
      refute is_valid?(schema, data)
    end

    @tag :draft4
    @tag :additional_properties
    test "ignores arrays", %{schema: schema} do
      data = [1, 2, 3]
      assert is_valid?(schema, data)
    end

    @tag :draft4
    @tag :additional_properties
    test "ignores strings", %{schema: schema} do
      data = "foobarbaz"
      assert is_valid?(schema, data)
    end

    @tag :draft4
    @tag :additional_properties
    test "ignores other non-objects", %{schema: schema} do
      data = 12
      assert is_valid?(schema, data)
    end

    @tag :draft4
    @tag :additional_properties
    test "patternProperties are not additional properties", %{schema: schema} do
      data = %{foo: 1, vroom: 2}
      assert is_valid?(schema, data)
    end
  end

  describe "additional_properties allows a schema which should validate" do
    setup do
      %{
        schema:
          Xema.new(
            :any,
            additional_properties: :boolean,
            properties: %{bar: :any, foo: :any}
          )
      }
    end

    @tag :draft4
    @tag :additional_properties
    test "no additional properties is valid", %{schema: schema} do
      data = %{foo: 1}
      assert is_valid?(schema, data)
    end

    @tag :draft4
    @tag :additional_properties
    test "an additional valid property is valid", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: true}
      assert is_valid?(schema, data)
    end

    @tag :draft4
    @tag :additional_properties
    test "an additional invalid property is invalid", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: 12}
      refute is_valid?(schema, data)
    end
  end

  describe "additional_properties can exist by itself" do
    setup do
      %{schema: Xema.new(:additional_properties, :boolean)}
    end

    @tag :draft4
    @tag :additional_properties
    test "an additional valid property is valid", %{schema: schema} do
      data = %{foo: true}
      assert is_valid?(schema, data)
    end

    @tag :draft4
    @tag :additional_properties
    test "an additional invalid property is invalid", %{schema: schema} do
      data = %{foo: 1}
      refute is_valid?(schema, data)
    end
  end

  describe "additional_properties are allowed by default" do
    setup do
      %{schema: Xema.new(:properties, %{bar: :any, foo: :any})}
    end

    @tag :draft4
    @tag :additional_properties
    test "additional properties are allowed", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: true}
      assert is_valid?(schema, data)
    end
  end
end
