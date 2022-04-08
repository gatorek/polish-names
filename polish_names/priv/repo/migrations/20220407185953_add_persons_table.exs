defmodule PolishNames.Repo.Migrations.AddPersonsTable do
  use Ecto.Migration

  def up do
    create table("persons") do
      add :name, :string
      add :surname, :string
      add :gender, :string
      add :birth_date, :date
    end
  end

  def down do
    drop table("persons")
  end
end
