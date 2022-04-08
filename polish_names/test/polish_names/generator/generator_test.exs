defmodule PolishNames.GeneratorTest do
  @moduledoc false

  use PolishNames.DataCase

  @male_names ["PIOTR", "KRZYSZTOF", "ANDRZEJ"]
  @male_surnames ["NOWAK", "KOWALSKI", "WIŚNIEWSKI"]
  @female_names ["ANNA", "KATARZYNA", "MARIA"]
  @female_surnames ["NOWAK", "KOWALSKA", "WIŚNIEWSKA"]

  describe "api client" do
    setup do
      get_names =
        Hammox.protect({PolishNames.Generator.impl(), :get_names, 2}, PolishNames.Generator)

      [get_names: get_names]
    end

    test "gets male names", %{get_names: get_names} do
      response = get_names.(:male, :names)
      assert length(response) == 100
      assert Enum.take(response, 3) == ["PIOTR", "KRZYSZTOF", "ANDRZEJ"]
    end

    test "gets male surnames", %{get_names: get_names} do
      response = get_names.(:male, :surnames)
      assert length(response) == 100
      assert Enum.take(response, 3) == ["NOWAK", "KOWALSKI", "WIŚNIEWSKI"]
    end

    test "gets female names", %{get_names: get_names} do
      response = get_names.(:female, :names)
      assert length(response) == 100
      assert Enum.take(response, 3) == ["ANNA", "KATARZYNA", "MARIA"]
    end

    test "gets female surnames", %{get_names: get_names} do
      response = get_names.(:female, :surnames)
      assert length(response) == 100
      assert Enum.take(response, 3) == ["NOWAK", "KOWALSKA", "WIŚNIEWSKA"]
    end
  end

  describe "radom names generator" do
    test "generates n random records" do
      # un-randomize generator
      :rand.seed(:exsplus, {1, 2, 3})

      Hammox.expect(
        PolishNames.Generator.impl(),
        :get_names,
        4,
        fn
          :male, :names -> @male_names
          :male, :surnames -> @male_surnames
          :female, :names -> @female_names
          :female, :surnames -> @female_surnames
        end
      )

      generate =
        Hammox.protect(
          {PolishNames.Generator.impl(), :generate, 1},
          PolishNames.Generator
        )

      assert [
               %{
                 birth_date: Date.utc_today() |> Timex.shift(days: -10296),
                 gender: :female,
                 name: "MARIA",
                 surname: "WIŚNIEWSKA"
               },
               %{
                 birth_date: Date.utc_today() |> Timex.shift(days: -30135),
                 gender: :female,
                 name: "MARIA",
                 surname: "KOWALSKA"
               },
               %{
                 birth_date: Date.utc_today() |> Timex.shift(days: -28669),
                 gender: :male,
                 name: "ANDRZEJ",
                 surname: "WIŚNIEWSKI"
               }
             ] == generate.(3)
    end
  end
end
