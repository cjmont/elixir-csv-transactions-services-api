defmodule TransactionsApiWeb.TransactionJSON do
  alias TransactionsApi.Transactions.Transaction

  @doc """
  Renders a list of transactions.
  """
  def index(%{transactions: transactions}) do
    %{data: for(transaction <- transactions, do: data(transaction))}
  end

  @doc """
  Renders a single transaction.
  """
  def show(%{transaction: transaction}) do
    %{data: data(transaction)}
  end

  defp data(%Transaction{} = transaction) do
    %{
      id: transaction.id,
      shk_id: transaction.shk_id,
      debtor_name: transaction.debtor_name,
      creditor_name: transaction.creditor_name,
      debtor_id: transaction.debtor_id,
      creditor_id: transaction.creditor_id,
      amount: transaction.amount,
      operation_date: transaction.operation_date,
      debtor_bank: transaction.debtor_bank,
      creditor_bank: transaction.creditor_bank
    }
  end
end
