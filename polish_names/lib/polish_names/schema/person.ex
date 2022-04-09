defmodule PolishNames.Schema.Person do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "persons" do
    field :name, :string
    field :surname, :string
    field :gender, Ecto.Enum, values: [:male, :female]
    field :birth_date, :date
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :surname, :gender, :birth_date])
    |> validate_required([:name, :surname, :gender, :birth_date])
  end
end
