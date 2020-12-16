defmodule Compo.Repo do
  use Ecto.Repo,
    otp_app: :compo,
    adapter: Ecto.Adapters.Postgres
end
