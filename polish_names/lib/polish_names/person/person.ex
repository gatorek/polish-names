defmodule PolishNames.Person do
  @moduledoc """
    Functions related to person management and querying
  """

  use Modular.AreaAccess, [__MODULE__]

  alias PolishNames.Schema.Person

  def impl do
    impl(__MODULE__)
  end

  @type person :: %{
          name: String.t(),
          surname: String.t(),
          gender: :male | :female,
          birth_date: Date.t()
        }

  @type id :: non_neg_integer()

  @type person_attrs :: %{
          optional(:name) => String.t(),
          optional(:surname) => String.t(),
          optional(:gender) => :male | :female,
          optional(:birth_date) => Date.t()
        }

  @doc """
    Mass import person records into database
  """
  @callback import() :: :ok | :error

  @doc """
    Returns persons list
  """
  @callback list() :: [Person.t()]

  @doc """
    Gets a single person
  """
  @callback get(id) :: {:ok, Person.t()} | {:error, :not_found}

  @doc """
    Creates person
  """
  @callback create(person_attrs) :: {:ok, Person.t()} | {:error, Ecto.Changeset.t()}

  @doc """
    Updates person
  """
  @callback update(Person.t(), person_attrs) :: {:ok, Person.t()} | {:error, Ecto.Changeset.t()}

  @doc """
    Deletes person
  """
  @callback delete(Person.t()) :: {:ok, Person.t()} | {:error, Ecto.Changeset.t()}

  @doc """
    Returns changeset of a person record
  """
  @callback change(Person.t(), person_attrs) :: Ecto.Changeset.t()
  @callback change(Person.t()) :: Ecto.Changeset.t()
end
