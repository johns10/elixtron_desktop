defmodule ElixtronDesktop.Server do
  use GenServer

  def start_link(opts), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  def open_browser(), do: GenServer.call(__MODULE__, {:open_browser})
  def connect(), do: GenServer.call(__MODULE__, {:connect})
  def navigate(url), do: GenServer.call(__MODULE__, {:navigate, url})

  @impl true
  def init(_args) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:open_browser}, _from, state) do
    task =
      Task.async(fn ->
        System.cmd("C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
          ["--remote-debugging-port=9222","--user-data-dir=C:\\elixtron"]
        )
      end)

    { :reply, :ok, Map.put(state, :chrome_task, task) }
  end

  def handle_call({:connect}, _from, state) do
    server = ChromeRemoteInterface.Session.new()
    {:ok, pages} = ChromeRemoteInterface.Session.list_pages(server)
    first_page = pages |> List.first()
    {:ok, page_pid} = ChromeRemoteInterface.PageSession.start_link(first_page)
    { :reply, :ok, Map.put(state, :page_pid, page_pid) }
  end

  def handle_call({:navigate, url}, _from, state) do
    ChromeRemoteInterface.RPC.Page.navigate(state.page_pid, %{url: url})
    { :reply, :ok, state }
  end

  def terminate(reason, state) do
    Process.exit(state.chrome_task.pid, reason)
    Task.await(state.chrome_task)
  end
end
