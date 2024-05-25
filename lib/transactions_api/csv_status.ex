defmodule TransactionsApi.CSVStatus do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{status: :pending, path: nil} end, name: __MODULE__)
  end

  def get_status do
    Agent.get(__MODULE__, & &1)
  end

  def set_status(status, path) do
    Agent.update(__MODULE__, fn _ -> %{status: status, path: path} end)
  end
end
