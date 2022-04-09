defmodule PolishNames.Person.PersonQuerying do
  alias PolishNames.Repo
  alias PolishNames.Schema.Person

  import Ecto.Query

  def list(params \\ %{}) do
    from(p in Person)
    |> filter(params)
    |> sort(params)
    |> Repo.all()
  end

  def get(id) do
    case Repo.get(Person, id) do
      nil -> {:error, :not_found}
      person -> {:ok, person}
    end
  end

  defp filter(query, params) do
    params
    |> Enum.reduce(query, fn {param, value}, acc ->
      acc |> filter_param(%{param => value})
    end)
  end

  defp filter_param(query, %{name: name}) do
    query
    |> where([p], ilike(p.name, ^"%#{name}%"))
  end

  defp filter_param(query, %{surname: surname}) do
    query
    |> where([p], ilike(p.surname, ^"%#{surname}%"))
  end

  defp filter_param(query, %{gender: gender}) do
    query
    |> where([p], p.gender == ^gender)
  end

  defp filter_param(query, %{date_from: date_from}) do
    query
    |> where([p], p.birth_date >= ^date_from)
  end

  defp filter_param(query, %{date_to: date_to}) do
    query
    |> where([p], p.birth_date <= ^date_to)
  end

  defp filter_param(query, _), do: query

  defp sort(query, %{sort: order}) do
    query
    |> order_by(^order)
  end

  defp sort(query, _), do: query
end
