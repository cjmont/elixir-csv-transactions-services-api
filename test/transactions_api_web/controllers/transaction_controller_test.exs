defmodule TransactionsApiWeb.TransactionControllerTest do
  use TransactionsApiWeb.ConnCase

  import TransactionsApi.TransactionsFixtures

  alias TransactionsApi.Transactions.Transaction

  @create_attrs %{
    shk_id: "7488a646-e31f-11e4-aace-600308960662",
    debtor_name: "some debtor_name",
    creditor_name: "some creditor_name",
    debtor_id: "some debtor_id",
    creditor_id: "some creditor_id",
    amount: "120.5",
    operation_date: ~U[2024-05-23 20:52:00Z],
    debtor_bank: "some debtor_bank",
    creditor_bank: "some creditor_bank"
  }
  @update_attrs %{
    shk_id: "7488a646-e31f-11e4-aace-600308960668",
    debtor_name: "some updated debtor_name",
    creditor_name: "some updated creditor_name",
    debtor_id: "some updated debtor_id",
    creditor_id: "some updated creditor_id",
    amount: "456.7",
    operation_date: ~U[2024-05-24 20:52:00Z],
    debtor_bank: "some updated debtor_bank",
    creditor_bank: "some updated creditor_bank"
  }
  @invalid_attrs %{shk_id: nil, debtor_name: nil, creditor_name: nil, debtor_id: nil, creditor_id: nil, amount: nil, operation_date: nil, debtor_bank: nil, creditor_bank: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, ~p"/api/transactions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/transactions", transaction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/transactions/#{id}")

      assert %{
               "id" => ^id,
               "amount" => "120.5",
               "creditor_bank" => "some creditor_bank",
               "creditor_id" => "some creditor_id",
               "creditor_name" => "some creditor_name",
               "debtor_bank" => "some debtor_bank",
               "debtor_id" => "some debtor_id",
               "debtor_name" => "some debtor_name",
               "operation_date" => "2024-05-23T20:52:00Z",
               "shk_id" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/transactions", transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transaction" do
    setup [:create_transaction]

    test "renders transaction when data is valid", %{conn: conn, transaction: %Transaction{id: id} = transaction} do
      conn = put(conn, ~p"/api/transactions/#{transaction}", transaction: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/transactions/#{id}")

      assert %{
               "id" => ^id,
               "amount" => "456.7",
               "creditor_bank" => "some updated creditor_bank",
               "creditor_id" => "some updated creditor_id",
               "creditor_name" => "some updated creditor_name",
               "debtor_bank" => "some updated debtor_bank",
               "debtor_id" => "some updated debtor_id",
               "debtor_name" => "some updated debtor_name",
               "operation_date" => "2024-05-24T20:52:00Z",
               "shk_id" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      conn = put(conn, ~p"/api/transactions/#{transaction}", transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, ~p"/api/transactions/#{transaction}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/transactions/#{transaction}")
      end
    end
  end

  defp create_transaction(_) do
    transaction = transaction_fixture()
    %{transaction: transaction}
  end
end
