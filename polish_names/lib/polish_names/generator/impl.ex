defmodule PolishNames.Generator.Impl do
  @moduledoc false

  @behaviour PolishNames.Generator

  @impl true
  defdelegate get_names(gender, datatype), to: PolishNames.Generator.APIClient, as: :call

  @impl true
  defdelegate call(gender, datatype), to: PolishNames.Generator.APIClient

  @impl true
  defdelegate generate(count), to: PolishNames.Generator.RandomNames
end
