defmodule PolishNames.PersonManagementTest do
  @moduledoc false

  use PolishNames.DataCase

  alias PolishNames.Repo
  alias PolishNames.Schema.Person

  import PolishNames.PersonFixtures

  @persons [
    %{
      birth_date: ~D[2000-01-01],
      gender: :female,
      name: "STEFANIA",
      surname: "GRODZIEŃSKA"
    },
    %{
      birth_date: ~D[1999-12-31],
      gender: :female,
      name: "ZOFIA",
      surname: "NAŁKOWSKA"
    },
    %{
      birth_date: ~D[1992-02-29],
      gender: :male,
      name: "ALBERT",
      surname: "HOHENZOLERN"
    }
  ]

  @valid_attrs %{
    birth_date: ~D[1969-12-31],
    gender: :female,
    name: "ALDONA",
    surname: "PUCHACKA"
  }

  describe "import/0" do
    test "imports persons into db" do
      Hammox.expect(
        PolishNames.Generator.impl(),
        :generate,
        fn count ->
          assert count == 100

          @persons
        end
      )

      import =
        Hammox.protect(
          {PolishNames.Person.impl(), :import, 0},
          PolishNames.Person
        )

      import.()

      db_persons = Repo.all(Person) |> Enum.sort()
      persons = Enum.sort(@persons)

      Enum.zip(db_persons, persons)
      |> Enum.each(fn {db_person, person} ->
        assert db_person.gender == person.gender
        assert db_person.name == person.name
        assert db_person.surname == person.surname
        assert Timex.equal?(db_person.birth_date, person.birth_date)
      end)
    end
  end

  describe "create/1" do
    setup do
      create =
        Hammox.protect(
          {PolishNames.Person.impl(), :create, 1},
          PolishNames.Person
        )

      [create: create]
    end

    test "creates a person", %{create: create} do
      assert {:ok, %Person{} = person} = create.(@valid_attrs)
      assert person.birth_date == ~D[1969-12-31]
      assert person.gender == :female
      assert person.name == "ALDONA"
      assert person.surname == "PUCHACKA"
    end

    test "create without necessary data returns error changeset", %{create: create} do
      assert {:error, %Ecto.Changeset{}} = create.(%{name: "STEFAN"})
    end
  end

  describe "udpate/2" do
    test "updates the person" do
      update =
        Hammox.protect(
          {PolishNames.Person.impl(), :update, 2},
          PolishNames.Person
        )

      person = person_fixture()

      assert {:ok, %Person{} = person} = update.(person, %{name: "ALBERT"})
      assert person == %{person | name: "ALBERT"}

      assert {:ok, %Person{} = person} = update.(person, %{surname: "BURCZYMUCHA"})
      assert person == %{person | surname: "BURCZYMUCHA"}

      assert {:ok, %Person{} = person} = update.(person, %{gender: :female})
      assert person == %{person | gender: :female}

      assert {:ok, %Person{} = person} = update.(person, %{birth_date: ~D/2000-03-21/})
      assert person == %{person | birth_date: ~D/2000-03-21/}
    end
  end

  describe "delete/1" do
    test "deletes person" do
      delete =
        Hammox.protect(
          {PolishNames.Person.impl(), :delete, 1},
          PolishNames.Person
        )

      person = person_fixture()
      assert {:ok, %Person{}} = delete.(person)
      assert {:error, :not_found} == PolishNames.Person.impl().get(person.id)
    end
  end

  describe "change/2" do
    test "returns changeset" do
      change =
        Hammox.protect(
          {PolishNames.Person.impl(), :change, 1},
          PolishNames.Person
        )

      person = person_fixture()
      assert %Ecto.Changeset{} = change.(person)
    end

    test "returns changeset with actual change" do
      change =
        Hammox.protect(
          {PolishNames.Person.impl(), :change, 2},
          PolishNames.Person
        )

      person = person_fixture()
      assert %Ecto.Changeset{changes: %{gender: :female}} = change.(person, %{gender: :female})
    end
  end
end
