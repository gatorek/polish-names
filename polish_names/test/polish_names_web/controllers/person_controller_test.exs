defmodule PolishNamesWeb.PersonControllerTest do
  use PolishNamesWeb.ConnCase

  alias PolishNames.Schema.Person

  @create_attrs %{
    birth_date: ~D[1999-09-09],
    gender: :female,
    name: "EUZEBIA",
    surname: "NIMFA"
  }

  @update_attrs %{
    gender: :female,
    name: "AFANAZJA"
  }

  @person %Person{
    id: 13,
    name: "ALOJZY",
    surname: "BĄBEL",
    gender: :male,
    birth_date: ~D/1961-07-18/
  }

  describe "index" do
    test "lists all persons", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :list,
        fn -> [@person] end
      )

      conn = get(conn, Routes.person_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Persons"
      assert html_response(conn, 200) =~ "ALOJZY"
    end
  end

  describe "new person" do
    test "renders form", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :change,
        fn _person ->
          Ecto.Changeset.change(%Person{})
        end
      )

      conn = get(conn, Routes.person_path(conn, :new))
      assert html_response(conn, 200) =~ "New Person"
    end
  end

  describe "create person" do
    test "redirects to show when data is valid", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :create,
        fn attrs ->
          assert attrs == @create_attrs
          {:ok, %{struct(Person, @create_attrs) | id: 11}}
        end
      )

      conn = post(conn, Routes.person_path(conn, :create), person: @create_attrs)

      assert %{id: "11"} = redirected_params(conn)
      assert redirected_to(conn) == Routes.person_path(conn, :show, 11)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :create,
        fn attrs ->
          assert attrs == %{name: "ANASTAZJA"}
          {:error, %Person{} |> Ecto.Changeset.change(%{name: "ANASTAZJA"})}
        end
      )

      conn = post(conn, Routes.person_path(conn, :create), person: %{name: "ANASTAZJA"})
      assert html_response(conn, 200) =~ "New Person"
      assert html_response(conn, 200) =~ "ANASTAZJA"
    end
  end

  describe "edit person" do
    test "renders form for editing chosen person", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :get,
        fn id ->
          assert id == 13

          {:ok, @person}
        end
      )
      |> Hammox.expect(
        :change,
        fn person ->
          assert person == @person

          @person |> Ecto.Changeset.change()
        end
      )

      conn = get(conn, Routes.person_path(conn, :edit, 13))
      assert html_response(conn, 200) =~ "Edit Person"
      assert html_response(conn, 200) =~ "ALOJZY"
    end
  end

  describe "update person" do
    test "redirects when data is valid", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :get,
        fn id ->
          assert id == 13

          {:ok, @person}
        end
      )
      |> Hammox.expect(
        :update,
        fn person, params ->
          assert person == @person
          assert params == %{
            name: "AFANAZJA",
            gender: :female
          }

          {:ok, %{@person | name: "AFANAZJA", gender: :female}}
        end
      )

      conn = put(conn, Routes.person_path(conn, :update, 13), person: @update_attrs)
      assert redirected_to(conn) == Routes.person_path(conn, :show, 13)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :get,
        fn id ->
          assert id == 13

          {:ok, @person}
        end
      )
      |> Hammox.expect(
        :update,
        fn person, params ->
          assert person == @person
          assert params == %{}

          {:error, @person |> Ecto.Changeset.change()}
        end
      )

      conn = put(conn, Routes.person_path(conn, :update, 13), person: %{})
      assert html_response(conn, 200) =~ "Edit Person"
    end
  end

  describe "delete person" do
    test "deletes chosen person", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :get,
        fn id ->
          assert id == 13

          {:ok, @person}
        end
      )
      |> Hammox.expect(
        :delete,
        fn person ->
          assert person == @person

          {:ok, @person}
        end
      )

      conn = delete(conn, Routes.person_path(conn, :delete, 13))
      assert redirected_to(conn) == Routes.person_path(conn, :index)
    end

    test "redirects with error when not found", %{conn: conn} do
      Hammox.expect(
        PolishNames.Person.impl(),
        :get,
        fn id ->
          assert id == 14

          {:error, :not_found}
        end
      )

      conn = delete(conn, Routes.person_path(conn, :delete, 14))
      assert redirected_to(conn) == Routes.person_path(conn, :index)
      assert get_flash(conn, :error) == "Person not found."
    end
  end
end