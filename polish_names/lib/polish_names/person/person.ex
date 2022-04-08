defmodule PolishNames.Person do
  @moduledoc """
    Functions related to person management and querying
  """

  use Modular.AreaAccess, [__MODULE__]

  def impl do
    impl(__MODULE__)
  end

  @type person :: %{
          name: String.t(),
          surname: String.t(),
          gender: :male | :female,
          birth_date: Date.t()
        }

  @doc """
    Mass import person records into database
  """
  @callback import() :: :ok | :error
end
