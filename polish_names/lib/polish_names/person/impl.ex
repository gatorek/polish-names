defmodule PolishNames.Person.Impl do
  @moduledoc false

  @behaviour PolishNames.Person

  @impl true
  defdelegate import(), to: PolishNames.Person.PersonManagement
end
