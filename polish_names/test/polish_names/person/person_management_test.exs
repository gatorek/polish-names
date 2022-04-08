defmodule PolishNames.PersonManagementTest do
  @moduledoc false

  use PolishNames.DataCase

  alias PolishNames.Repo
  alias PolishNames.Schema.Person

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

  describe "mass import" do
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

      db_persons = Repo.all(Person) |> Enum.sort
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
end
