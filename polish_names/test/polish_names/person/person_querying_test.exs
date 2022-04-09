defmodule PolishNames.PersonQueryingTest do
  @moduledoc false

  use PolishNames.DataCase

  import PolishNames.PersonFixtures

  describe "list/0" do
    test "returns all persons" do
      list =
        Hammox.protect(
          {PolishNames.Person.impl(), :list, 0},
          PolishNames.Person
        )

      person = person_fixture()
      assert list.() == [person]
    end
  end

  describe "get/1" do
    test "returns the person with given id and error for non-existing id" do
      person = person_fixture()

      get =
        Hammox.protect(
          {PolishNames.Person.impl(), :get, 1},
          PolishNames.Person
        )

      assert get.(person.id) == {:ok, person}
      assert get.(person.id + 1) == {:error, :not_found}
    end
  end
end
