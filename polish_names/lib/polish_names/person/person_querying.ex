defmodule PolishNames.Person.PersonQuerying do
  alias PolishNames.Repo
  alias PolishNames.Schema.Person

  def list do
    Repo.all(Person)
  end

  def get(id) do
    case Repo.get(Person, id) do
      nil -> {:error, :not_found}
      person -> {:ok, person}
    end
  end
end
