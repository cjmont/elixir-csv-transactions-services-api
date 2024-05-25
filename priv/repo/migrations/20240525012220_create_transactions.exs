defmodule TransactionsApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :shk_id, :uuid
      add :debtor_name, :string
      add :creditor_name, :string
      add :debtor_id, :string
      add :creditor_id, :string
      add :amount, :decimal, scale: 2, precision: 10
      add :operation_date, :utc_datetime
      add :debtor_bank, :string
      add :creditor_bank, :string

      timestamps()
    end
  end
end
