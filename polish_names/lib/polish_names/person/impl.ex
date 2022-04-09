defmodule PolishNames.Person.Impl do
  @moduledoc false

  @behaviour PolishNames.Person

  @impl true
  defdelegate import(), to: PolishNames.Person.PersonManagement

  @impl true
  defdelegate list(), to: PolishNames.Person.PersonQuerying

  @impl true
  defdelegate get(id), to: PolishNames.Person.PersonQuerying

  @impl true
  defdelegate create(attr), to: PolishNames.Person.PersonManagement

  @impl true
  defdelegate update(person, attr), to: PolishNames.Person.PersonManagement

  @impl true
  defdelegate delete(person), to: PolishNames.Person.PersonManagement

  @impl true
  defdelegate change(person, attr \\ %{}), to: PolishNames.Person.PersonManagement
end
