defmodule PushsumProtocol do
  import ActorFunc

  def start_link(node_id, neighbors, _perc_faulty_nodes) do
    GenServer.start_link(__MODULE__, [node_id, neighbors], name: via_tuple(node_id))
  end

  def init([node_id, neighbors]) do
    receive do
      {_, s, w} -> startHelperProcess(node_id, neighbors, s, w)
    end

    {:ok, node_id}
  end

  def startHelperProcess(node_id, neighbors, s, w) do
    # s=1
    # w=3
    {:ok, callingProc} = Task.start(fn -> call_neighbor(node_id, neighbors) end)
    listen(0, s + node_id, w + 1, node_id, callingProc)
  end

  def listen(count, s, w, oldsbyw, callingProc) do
    newsbyw = s / w
    count = if abs(newsbyw - oldsbyw) > :math.pow(10, -10), do: 0, else: count + 1
     # IO.puts "newsbyw value #{newsbyw}"
     # IO.puts "b value #{s}"
     # IO.puts "w value #{w}"
    processConvergenceAndListen(count, callingProc, s, w, newsbyw)
    # listen(count, s, w, oldsbyw, callingProc)
  end

  def processConvergenceAndListen(count, callingProc, _s, _w, _sbyw) when count >= 3 do
    # IO.puts "con value #{sbyw}"
    shutdown(callingProc)
  end

  def processConvergenceAndListen(count, callingProc, s, w, sbyw) when count < 3 do
    s = s / 2
    w = w / 2
    send(callingProc, {:call_neigh, s, w})

    receive do
      {:newVal, newS, newW} -> listen(count, newS + s, newW + w, sbyw, callingProc)
    after
      100 -> listen(count, s, w, sbyw, callingProc)
    end
    # listen(count, s, w, sbyw, callingProc)
  end

  def call_neighbor(node_id, neighbors) do
    receive do
      {:call_neigh, s, w} ->
        # IO.puts "calling neighbors #{inspect(neighbors)}"
        Enum.random(neighbors) |> getPid() |> send_pushsum(s, w)
    end

    #  Process.sleep(100)
    call_neighbor(node_id, neighbors)
  end

  def send_pushsum(pid, s, w) do
    if pid != nil do
      send(pid, {:newVal, s, w})
    end
  end
end
