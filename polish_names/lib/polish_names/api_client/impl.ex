defmodule PolishNames.APIClient.Impl do
  @moduledoc false

  @behaviour PolishNames.APIClient

  @impl true
  defdelegate call(gender, datatype), to: PolishNames.APIClient.HttpClient
end
