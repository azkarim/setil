defmodule Setil.Repo do
  use Ecto.Repo,
    otp_app: :setil,
    adapter: Ecto.Adapters.Postgres
end
