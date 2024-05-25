defmodule TransactionsApiWeb.Router do
  use TransactionsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug TransactionsApiWeb.Plugs.Authentication
  end

  scope "/api", TransactionsApiWeb do
    pipe_through :api

    post "/transactions", TransactionController, :create
    get "/transactions/download", TransactionController, :download
    post "/transactions/generate_csv", TransactionController, :generate_csv
    get "/transactions/download_async", TransactionController, :download_async
  end


  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:transactions_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TransactionsApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
