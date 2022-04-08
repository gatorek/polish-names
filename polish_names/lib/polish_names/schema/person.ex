defmodule PolishNames.Schema.Person do
  use Ecto.Schema

  schema "persons" do
    field :name, :string
    field :surname, :string
    field :gender, Ecto.Enum, values: [:male, :female]
    field :birth_date, :date
  end
end
