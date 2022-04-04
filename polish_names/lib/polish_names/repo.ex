defmodule PolishNames.Repo do
  use Ecto.Repo,
    otp_app: :polish_names,
    adapter: Ecto.Adapters.Postgres
end
