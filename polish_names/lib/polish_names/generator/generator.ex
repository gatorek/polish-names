defmodule PolishNames.Generator do
  @moduledoc """
    Functions making API calls and parsing responses
  """

  use Modular.AreaAccess, [__MODULE__]

  def impl do
    impl(__MODULE__)
  end

  @type gender :: :male | :female
  @type datatype :: :names | :surnames
  @type name :: String.t()
  @type count :: non_neg_integer()
  @type person :: %{
          name: String.t(),
          surname: String.t(),
          gender: gender,
          birth_date: Date.t()
        }

  @doc """
    Returns list of most popular names/surnames for given gender
  """
  @callback get_names(gender, datatype) :: [name]

  @doc """
    list of most popular names/surnames, just for mocking purposes
  """
  @callback call(gender, datatype) :: [name]

  @doc """
    Import random records into database
  """
  @callback generate(count) :: [person]
end
