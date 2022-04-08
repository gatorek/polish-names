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
end
