defmodule PolishNames.Generator.RandomNames do
  @moduledoc false

  @genders [:male, :female]
  @min_years 18
  @max_years 99

  def generate(count) do
    names = %{
      male_names: get_names(:male, :names),
      male_surnames: get_names(:male, :surnames),
      female_names: get_names(:female, :names),
      female_surnames: get_names(:female, :surnames)
    }

    Stream.repeatedly(fn -> random(names) end)
    |> Enum.take(count)
  end

  defp random(names) do
    case Enum.random(@genders) do
      :female ->
        %{
          name: Enum.random(names.female_names),
          surname: Enum.random(names.female_surnames),
          gender: :female,
          birth_date: random_date()
        }

      :male ->
        %{
          name: Enum.random(names.male_names),
          surname: Enum.random(names.male_surnames),
          gender: :male,
          birth_date: random_date()
        }
    end
  end

  defp random_date() do
    Date.range(
      Date.utc_today() |> Timex.shift(years: -@max_years),
      Date.utc_today() |> Timex.shift(years: -@min_years)
    )
    |> Enum.random()
  end

  defp get_names(gender, datatype) do
    PolishNames.Generator.impl().get_names(gender, datatype)
  end
end
