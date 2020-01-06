defmodule Proj2 do
  def main(numNodes, topology, algorithm, perc_faulty_nodes) do
    Registry.start_link(keys: :unique, name: :registry)
    case algorithm do
      "gossip" -> Initialize_Actors.start(numNodes, topology, :gossip, algorithm, perc_faulty_nodes)
      "pushsum" -> Initialize_Actors.start(numNodes, topology, {:pushsum, 0, 0}, algorithm, perc_faulty_nodes)
    end
  end
end

defmodule Initialize_Actors do
  import Topologies
  def start(numNodes, topology, message, algorithm, perc_faulty_nodes) do
    perc_faulty_nodes = perc_faulty_nodes/100
    numNodes = trunc(numNodes - :math.ceil(numNodes*perc_faulty_nodes))
    init_actors(numNodes, topology,algorithm, perc_faulty_nodes)
     start_time = System.system_time(:millisecond)
    Init_protocol.initiate_process(numNodes, message)
    convergence_time = System.system_time(:millisecond) - start_time
    # IO.puts ("#{algorithm} - Converged")
    IO.puts("Time required to achieve convergence: #{convergence_time} milliseconds")
  end

  def init_actors(numNodes, topology, algorithm, perc_faulty_nodes) do
    numNodes = correctNumNodesForGrids(numNodes, topology)
    list_nodes = 1..numNodes
    shuffled_nodes = Enum.shuffle(list_nodes) |> Enum.with_index(1)

    # rand = Enum.random(0..1_00)
    # rand = rand/100
    # IO.puts("#{rand},#{perc_faulty_nodes}")
    # if rand <= perc_faulty_nodes do
      case algorithm do
        "gossip" -> for i <- list_nodes do
                spawn(fn -> GossipProtocol.start_link(i, getNeighbor(list_nodes,i,numNodes, topology, shuffled_nodes),perc_faulty_nodes) end)
                |> Process.monitor()
                end

      "pushsum" ->
        for i <- list_nodes do
              spawn(fn -> PushsumProtocol.start_link(i, getNeighbor(list_nodes, i, numNodes, topology, shuffled_nodes),perc_faulty_nodes) end)
              |> Process.monitor()
      end
    # end

    end
  end

end
