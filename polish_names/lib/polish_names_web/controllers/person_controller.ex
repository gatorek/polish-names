defmodule PolishNamesWeb.PersonController do
  @moduledoc false

  use PolishNamesWeb, :controller

  alias PolishNames.Person, as: PersonBehavior
  alias PolishNames.Schema.Person

  @ordering ~w/name surname gender birth_date/
  @genders ~w/female male/

  def import(conn, _params) do
    case PersonBehavior.impl().import() do
      :ok ->
        conn
        |> put_flash(:info, "Import succesfull")
        |> redirect(to: Routes.person_path(conn, :index))

      :error ->
        conn
        |> put_flash(:error, "Import failed")
        |> redirect(to: Routes.person_path(conn, :index))
    end
  end

  def index(conn, index_params) do
    with {:ok, params} <- parse_index_params(index_params),
         persons <- PersonBehavior.impl().list(params) do
      render(conn, "index.html", persons: persons, params: params)
    else
      {:error, :invalid_parameter} ->
        error_invalid_params(conn)
    end
  end

  def new(conn, _params) do
    changeset = PersonBehavior.impl().change(%Person{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"person" => person_params}) do
    with {:ok, params} <- parse_person_params(person_params),
         {:ok, person} <- PersonBehavior.impl().create(params) do
      conn
      |> put_flash(:info, "Person created successfully.")
      |> redirect(to: Routes.person_path(conn, :show, person))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)

      {:error, :invalid_parameter} ->
        error_invalid_params(conn)
    end
  end

  def show(conn, %{"id" => id}) do
    {:ok, person} = PersonBehavior.impl().get(id)
    render(conn, "show.html", person: person)
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, id} <- parse_id(id),
         {:ok, person} <- PersonBehavior.impl().get(id),
         changeset <- PersonBehavior.impl().change(person) do
      render(conn, "edit.html", person: person, changeset: changeset)
    else
      {:error, :not_found} -> error_not_found(conn)
      {:error, :invalid_parameter} -> error_invalid_params(conn)
    end
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    with {:ok, id} <- parse_id(id),
         {:ok, params} <- parse_person_params(person_params),
         {:ok, person} <- PersonBehavior.impl().get(id) do
      case PersonBehavior.impl().update(person, params) do
        {:ok, person} ->
          conn
          |> put_flash(:info, "Person updated successfully.")
          |> redirect(to: Routes.person_path(conn, :show, person))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", person: person, changeset: changeset)
      end
    else
      {:error, _} -> error_not_found(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, id} <- parse_id(id),
         {:ok, person} <- PersonBehavior.impl().get(id),
         {:ok, _person} <- PersonBehavior.impl().delete(person) do
      conn
      |> put_flash(:info, "Person deleted successfully.")
      |> redirect(to: Routes.person_path(conn, :index))
    else
      {:error, :not_found} -> error_not_found(conn)
      {:error, :invalid_parameter} -> {:error, :invalid_parameter}
      {:error, _} -> error(conn, "Couldn't delete person")
    end
  end

  defp error_not_found(conn) do
    conn
    |> put_flash(:error, "Person not found.")
    |> redirect(to: Routes.person_path(conn, :index))
  end

  defp error(conn, message) do
    conn
    |> put_flash(:error, message)
    |> redirect(to: Routes.person_path(conn, :index))
  end

  defp error_invalid_params(conn) do
    send_resp(conn, 400, "Invalid parameters")
  end

  defp parse_person_params(params) do
    params
    |> Enum.reduce_while(%{}, fn {key, val}, acc ->
      case key do
        "name" ->
          {:cont, Map.put(acc, :name, val)}

        "surname" ->
          {:cont, Map.put(acc, :surname, val)}

        "gender" when val in @genders ->
          {:cont, Map.put(acc, :gender, String.to_atom(val))}

        "birth_date" ->
          {:cont, Map.put(acc, :birth_date, Date.from_iso8601!(val))}

        _ ->
          {:halt, {:error, :invalid_parameter}}
      end
    end)
    |> case do
      {:error, :invalid_parameter} -> {:error, :invalid_parameter}
      params -> {:ok, params}
    end
  end

  defp parse_index_params(params) do
    params
    |> Enum.reduce_while(%{}, fn {key, val}, acc ->
      case key do
        "sort" when val in @ordering ->
          {:cont, Map.put(acc, :sort, String.to_atom(val))}

        "name" ->
          {:cont, Map.put(acc, :name, val)}

        "surname" ->
          {:cont, Map.put(acc, :surname, val)}

        "gender" when val in @genders ->
          {:cont, Map.put(acc, :gender, String.to_atom(val))}

        "date_from" ->
          {:cont, Map.put(acc, :date_from, Date.from_iso8601!(val))}

        "date_to" ->
          {:cont, Map.put(acc, :date_to, Date.from_iso8601!(val))}

        _ ->
          {:halt, {:error, :invalid_parameter}}
      end
    end)
    |> case do
      {:error, :invalid_parameter} -> {:error, :invalid_parameter}
      params -> {:ok, params}
    end
  end

  defp parse_id(string_id) do
    case Integer.parse(string_id) do
      {id, ""} -> {:ok, id}
      _ -> {:error, :invalid_parameter}
    end
  end
end
