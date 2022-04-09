defmodule PolishNames.Person.PersonManagement do
  alias PolishNames.Repo
  alias PolishNames.Schema.Person

  @import_count 100

  def import() do
    with persons <- PolishNames.Generator.impl().generate(@import_count),
         {_, nil} <- Repo.delete_all(Person),
         {_, nil} <- Repo.insert_all(Person, persons) do
      :ok
    else
      _ ->
        Repo.delete_all(Person)
        :error
    end
  end

  def create(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Person{} = person) do
    Repo.delete(person)
  end

  def change(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end
end
