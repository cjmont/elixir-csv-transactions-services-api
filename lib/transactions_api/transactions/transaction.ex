defmodule TransactionsApi.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :shk_id, Ecto.UUID
    field :debtor_name, :string
    field :creditor_name, :string
    field :debtor_id, :string
    field :creditor_id, :string
    field :amount, :decimal
    field :operation_date, :utc_datetime
    field :debtor_bank, :string
    field :creditor_bank, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:shk_id, :debtor_name, :creditor_name, :debtor_id, :creditor_id, :amount, :operation_date, :debtor_bank, :creditor_bank])
    |> validate_required([:shk_id, :debtor_name, :creditor_name, :debtor_id, :creditor_id, :amount, :operation_date, :debtor_bank, :creditor_bank])
  end
end
