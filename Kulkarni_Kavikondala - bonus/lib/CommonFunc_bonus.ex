defmodule Init_protocol do
  def initiate_process(numNodes, message) do
    convergence_task = Task.async(fn -> listenConvergence(numNodes) end)
    :global.register_name(:convergence_task_pid, convergence_task.pid)
    start_process_on_random_node(numNodes, message)
    Task.await(convergence_task, :infinity)
  end

  def listenConvergence(numNodes) do
    if(numNodes > 0) do
      receive do
        {:converged, pid} ->
            IO.puts("Converged node #{inspect(pid)}")  #remaining nodes: #{numNodes}")`
          listenConvergence(numNodes - 1)
      after
        1000 ->
          if numNodes != 1 do
          IO.puts("Node not Converged ")
        end
             listenConvergence(numNodes - 1)
      end
    end
  end

  def start_process_on_random_node(numNodes, message) do
    node_pid = numNodes |> :rand.uniform() |> ActorFunc.getPid()

    if node_pid != nil do
      send(node_pid, message)
    else
      start_process_on_random_node(numNodes, message)
    end
  end
end

defmodule ActorFunc do
  def via_tuple(node_id), do: {:via, Registry, {:registry, node_id}}

  def getPid(node_id) do
    case Registry.lookup(:registry, node_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def shutdown(pid) do
    send(:global.whereis_name(:convergence_task_pid), {:converged, self()})
    Task.shutdown(pid, :kill)
  end
end
