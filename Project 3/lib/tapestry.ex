defmodule Tapestry do
use GenServer

def main(numNodes,numRequests) do

  IO.puts("Number of Nodes: #{numNodes}")
  IO.puts("Number of Requests: #{numRequests}")
  {:ok,pid} = GenServer.start_link(__MODULE__, [numNodes,numRequests], name: {:global, :tapestry})
  startWorkerNodes(numNodes, numRequests)
end

def init(pid ) do
  {:ok, pid}
end

def startWorkerNodes(numNodes,numRequests) do   #ch
    # IO.puts("In createNodes")
    list_nodes = Enum.map(1 .. numNodes,
    fn x ->
    node_sha = :crypto.hash(:sha, "#{x}") |> Base.encode16() |> String.slice(0..9)          #Slicing 40 digit sha into 9 digits
    # IO.inspect(node_sha)
    # {:ok, pid} =
    Tapestry_nodes.start_link(node_sha, numRequests)
    end )
    # IO.inspect (list_nodes)
    list_nodes = Enum.shuffle(list_nodes)
    node_join = Enum.at(list_nodes, numNodes - 1)
    # IO.inspect (node_join)

    nodes_rt = List.delete(list_nodes, node_join)
    # IO.inspect(nodes_rt)
    IO.puts("Build Routing Tables for each node in network.")
    routingtable(nodes_rt)
    GenServer.call( node_join , { :filltable,  nodes_rt } )
    IO.puts("Join a new node in the existing network.")
    joinNode(node_join, nodes_rt)
    nodes_hash = Enum.map( list_nodes, fn x ->
    hash_n = GenServer.call(x,{:gethash}) end)
    IO.puts("Sending Requests to nodes")
    routingNodes(list_nodes, numRequests, nodes_hash)

end



def routingtable(nodelist) do
  # IO.puts("In routing table")
  Enum.each(nodelist, fn x ->
       GenServer.call(x,{:routingtable, nodelist})
     end )
end


def joinNode(node_join, nodelist) do
  # IO.puts("In join node")
  # IO.puts("----------------------e----------------")
  n = length(nodelist)
  randnode = Enum.at(nodelist, Enum.random(0..n))
  node_hash = GenServer.call(node_join, {:gethash})
  [max_prefix_id, max_prefix] = GenServer.call(node_join,{:joinNode, node_hash, nodelist})
  # IO.inspect(max_prefix_id)
  if max_prefix_id != 0 do
    GenServer.cast( node_join , {:updatert, max_prefix_id, max_prefix } )
  end
end

def routingNodes(list_nodes, numRequests, nodes_hash) do
  Enum.each(list_nodes, fn x->
    Process.sleep(10)
    GenServer.cast(x, {:routing, list_nodes, numRequests, nodes_hash}) end)
    # IO.puts("Initial Maxhops: 0")

end

def handle_info({:catchhops, hops}, state) do
   # IO.puts("IN catchhops")
   # IO.inspect(state)
   x = Enum.at(state,1)
  # IO.puts("x:#{x}")
  # IO.puts("hops: #{hops}")
   maxhops = if hops > x  do
    IO.puts("MaxHop: #{hops}")
    hops
  else
    state
  end
    IO.puts("Max Hops: #{hops}")
    # IO.inspect(maxhops)
  {:noreply, maxhops}
end




end
