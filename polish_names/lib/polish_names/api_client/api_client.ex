defmodule PolishNames.APIClient do
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

  @doc """
    Returns list of most popular names/surnames for given gender
  """
  @callback call(gender, datatype) :: [name]
end
