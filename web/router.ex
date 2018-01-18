defmodule RogerUi.RouterPlug do
  @moduledoc """
  Plug to expose RogerUi API
  """

  require Logger
  alias RogerUi.RouterPlug.Router

  alias Roger.Info

  def init(opts), do: opts

  def call(conn, opts) do
    Router.call(conn, Router.init(opts))
  end

  defmodule Router do
    @moduledoc """
    Plug Router extension
    """

    import Plug.Conn
    use Plug.Router

    plug Plug.Static,
      at: "/",
      from: :roger_ui,
      only: ~w(assets templates)

    plug :match
    plug :dispatch

    get "/api/partitions" do
      partitions = Info.running_partitions()
      |> Enum.into(%{})
      {:ok, json} = Poison.encode(%{partitions: partitions})

      new_json = ~s({"partitions":{"watcher@big-people":{},"demo@big-people":{"roger_demo_partition":{"other":{"paused":false,"message_count":0,"max_workers":2,"consumer_count":1},"default":{"paused":false,"message_count":0,"max_workers":10,"consumer_count":1}}}}})
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, new_json)
      |> halt()
    end

    get "/api/queues/:partition_name/:queue_name" do
      running_jobs = Info.running_jobs(partition_name);
      queued_jobs = Info.queued_jobs(partition_name, queued_name);
      |> Enum.into(%{})
      {:ok, json} = Poison.encode(%{partitions: partitions})

      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, json)
      |> halt()
    end

    match _ do
      index_path = Path.join([Application.app_dir(:roger_ui), "priv/static/index.html"])
      conn
      |> put_resp_header("content-type", "text/html")
      |> send_file(200, index_path)
      |> halt()
    end
  end
end
