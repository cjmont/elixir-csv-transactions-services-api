defmodule TransactionsApiWeb.TransactionController do
  use TransactionsApiWeb, :controller
  alias TransactionsApi.Transactions
  alias TransactionsApi.Transactions.Transaction
  alias TransactionsApi.CSVStatus

  require Logger

  plug :validate_headers

  def create(conn, %{"transaction" => transaction_params}) do
    Logger.info("Received request to create transaction with params: #{inspect(transaction_params)}")

    changeset = Transactions.transaction_changeset(%Transaction{}, transaction_params)

    if changeset.valid? do
      Logger.info("Changeset is valid. Proceeding with transaction creation.")
      Task.start(fn -> Transactions.create_transaction(changeset.params) end)

      Logger.info("Sending accepted response back to client.")
      conn
      |> put_status(:created)
      |> json(%{status: "Processing", message: "La transacción se está procesando."})
    else
      Logger.error("Changeset is invalid: #{inspect(changeset)}")
      conn
      |> put_status(:bad_request)
      |> render("error.json", changeset: changeset)
    end
  end

  def generate_csv(conn, _params) do
    Logger.info("Received request to generate CSV.")
    Task.start(fn -> async_generate_csv() end)
    conn
    |> put_status(:accepted)
    |> json(%{status: "CSV generation started", link: "/api/transactions/download_async"})
  end

  def download_async(conn, _params) do
    case CSVStatus.get_status() do
      %{status: :ready, path: path} when not is_nil(path) ->
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"transactions.csv\"")
        |> send_file(200, path)

      _ ->
        conn
        |> put_status(:too_early)
        |> json(%{error: "CSV file is not ready yet"})
    end
  end

  def download(conn, _params) do
    case CSVStatus.get_status() do
      %{status: :ready, path: path} when not is_nil(path) ->
        #csv read from path priv/static/transactions.csv
        csv_path = Path.join([:code.priv_dir(:transactions_api), "static", "transactions.csv"])

        conn
        |> put_status(:ok)
        |> json(%{status: "CSV file ready", link: csv_path})

      _ ->
        conn
        |> put_status(:too_early)
        |> json(%{error: "CSV file is not ready yet"})
    end
  end

  defp async_generate_csv do
    transactions = Transactions.list_transactions()
    csv_content = encode_to_csv(transactions)
    path = "priv/static/transactions.csv"

    File.write!(path, csv_content)
    CSVStatus.set_status(:ready, path)
  end

  defp encode_to_csv(transactions) do
    headers = ["shk_id", "debtor_name", "creditor_name", "debtor_id", "creditor_id", "amount", "operation_date", "debtor_bank", "creditor_bank"]

    csv_data =
      transactions
      |> Enum.map(fn transaction ->
        [
          transaction.shk_id,
          transaction.debtor_name,
          transaction.creditor_name,
          transaction.debtor_id,
          transaction.creditor_id,
          Decimal.to_string(transaction.amount),
          DateTime.to_string(transaction.operation_date),
          transaction.debtor_bank,
          transaction.creditor_bank
        ]
      end)

    CSV.encode([headers] ++ csv_data)
    |> Enum.join("\n")
  end

  defp validate_headers(conn, _opts) do
    shk_usr = get_req_header(conn, "shk_usr")
    shk_pwd = get_req_header(conn, "shk_pwd")

    if Enum.empty?(shk_usr) or Enum.empty?(shk_pwd) or Enum.at(shk_usr, 0) == "" or Enum.at(shk_pwd, 0) == "" do
      Logger.error("Missing or empty authentication headers")
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Missing or empty authentication headers"})
      |> halt()
    else
      conn
    end
  end
end
