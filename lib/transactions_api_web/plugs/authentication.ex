defmodule TransactionsApiWeb.Plugs.Authentication do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _opts) do
    shk_usr = get_req_header(conn, "shk_usr") |> List.first()
    shk_pwd = get_req_header(conn, "shk_pwd") |> List.first()

    if shk_usr && shk_pwd && shk_usr != "" && shk_pwd != "" do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Forbidden"})
      |> halt()
    end
  end
end
