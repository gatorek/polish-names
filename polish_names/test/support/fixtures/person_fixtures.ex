defmodule PolishNames.PersonFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PolishNames.Person` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[1999-01-01],
        gender: :male,
        name: "ADAM",
        surname: "ASNYK"
      })
      |> PolishNames.Person.impl().create()

    person
  end
end
