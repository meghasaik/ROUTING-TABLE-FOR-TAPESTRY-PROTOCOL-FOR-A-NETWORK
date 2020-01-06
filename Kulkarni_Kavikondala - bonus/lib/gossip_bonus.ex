defmodule GossipProtocol do
  import ActorFunc

  def start_link(node_id, neighbors,perc_faulty_nodes) do
    GenServer.start_link(__MODULE__, [node_id, neighbors,perc_faulty_nodes], name: via_tuple(node_id))
  end

  def init([node_id, neighbors,perc_faulty_nodes]) do
    receive do
      :gossip ->
        gossiping_task = Task.start(fn -> start_gossiping(node_id, neighbors,perc_faulty_nodes) end)

        listen(1, gossiping_task,perc_faulty_nodes)
    end

    {:ok, node_id}
  end

  def listen(count, gossiping_task,perc_faulty_nodes) when count <= 10 do
    receive do
      :gossip -> listen(count + 1, gossiping_task,perc_faulty_nodes)
    end
  end

  def listen(count, gossiping_task,perc_faulty_nodes) when count > 10 do
    shutdown(gossiping_task)
  end

  def start_gossiping(node_id, neighbors,perc_faulty_nodes) do
    # rand = Enum.random(0..100)
    # rand = rand/100
    #
    # if rand <= perc_faulty_nodes do
      # IO.puts("#{rand} , #{perc_faulty_nodes}")
      Enum.random(neighbors) |> getPid() |> send_gossip
      Process.sleep(100)
      start_gossiping(node_id, neighbors,perc_faulty_nodes)
   # end
  end

  defp send_gossip(pid) do
    if pid != nil do
      send(pid, :gossip)
    end
  end
end
