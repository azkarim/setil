defmodule Setil.Repo.Migrations.AddPreferredNameToUsers2 do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :preferred_name, :string
    end
  end
end
