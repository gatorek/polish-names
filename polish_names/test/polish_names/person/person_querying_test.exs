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

    test "filters results" do
      list =
        Hammox.protect(
          {PolishNames.Person.impl(), :list, 1},
          PolishNames.Person
        )

      person = person_fixture()
      assert list.(%{name: "ada"}) == [person]
      assert list.(%{name: "adb"}) == []
      assert list.(%{surname: "asn"}) == [person]
      assert list.(%{surname: "ask"}) == []
      assert list.(%{gender: :male}) == [person]
      assert list.(%{gender: :female}) == []
      assert list.(%{date_from: ~D/1999-01-01/}) == [person]
      assert list.(%{date_from: ~D/1999-01-02/}) == []
      assert list.(%{date_to: ~D/1999-01-01/}) == [person]
      assert list.(%{date_to: ~D/1998-12-31/}) == []
      assert list.(%{name: "ada", surname: "nyk"}) == [person]
      assert list.(%{name: "ada", surname: "nyka"}) == []
      assert list.(%{date_from: ~D/1999-01-01/, date_to: ~D/1999-01-01/}) == [person]
      assert list.(%{date_from: ~D/1999-01-02/, date_to: ~D/1998-12-31/}) == []
    end

    test "sorts results" do
      list =
        Hammox.protect(
          {PolishNames.Person.impl(), :list, 1},
          PolishNames.Person
        )

      person_1 = person_fixture()

      person_2 =
        person_fixture(
          name: "ABOLICJA",
          surname: "BĄCZEK",
          gender: :female,
          birth_date: ~D/1999-01-02/
        )

      assert list.(%{sort: :name}) == [person_2, person_1]
      assert list.(%{sort: :surname}) == [person_1, person_2]
      assert list.(%{sort: :gender}) == [person_2, person_1]
      assert list.(%{sort: :birth_date}) == [person_1, person_2]
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
