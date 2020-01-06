defmodule Tapestry_nodes do
use GenServer

 def start_link(node_id, numRequests) do
    # IO.puts("In Tapestry_nodes")
    {:ok, pid} = GenServer.start_link(__MODULE__, [node_id,numRequests], name: String.to_atom(node_id) )
    pid
    # IO.inspect(pid)
 end

 def init([node_id, numRequests]) do
   # IO.puts("init-tapestrynodes")
   routingtable = Enum.map(1..9, fn x -> Enum.map(1..16, fn y -> y= 0 end) end)
   {:ok, %{ pid: self(), node_id: node_id, numRequests: numRequests, routingtable: routingtable}}
   # self()
 end

def handle_call({:routingtable, nodelist}, _from, state) do  #change
     current_node = Map.get(state, :node_id)
     # IO.puts("In :routingtable")
     nodelist = List.delete(nodelist, self())                  #xhash is node b
     Enum.each( nodelist, fn x->
       node_sha = GenServer.call( x, {:gethash})
       GenServer.cast( self(), {:updatetable, current_node, node_sha})
     end )
     {:reply, current_node, state}
end

def handle_call({:gethash}, _from, state) do

    # IO.puts("In :gethash ")
    node_sha = Map.get(state, :node_id)
    {:reply, node_sha, state}
end

def handle_cast({:updatetable, node1, node2}, state) do
x_val = prefix_match(node1,node2,0)
# IO.puts("In :updatetable")
val = String.at(node2, x_val)
y_val= cond do
  val == "A" -> 10
  val == "B" -> 11
  val == "C" -> 12
  val == "D" -> 13
  val == "E" -> 14
  val == "F" -> 15
  true -> String.to_integer(val)
end

routingtable = Map.get(state, :routingtable)
list = Enum.at(routingtable, x_val)
list = List.replace_at(list,y_val, node2)
routingtable = List.replace_at(routingtable,x_val, list)

state = Map.put(state, :routingtable, routingtable)
# IO.inspect(state)
{:noreply, state}

end

def prefix_match(node1,node2,index) do
  if(String.slice(node1, 0,1) == String.slice(node2, 0 ,1)) do
    node1 = String.slice(node1, 1.. String.length(node1))
    node2 = String.slice(node1, 1.. String.length(node2))
    prefix_match(node1,node2, index + 1)
  else
    index
  end
end

def handle_call({:joinNode, new_node, list_nodes}, _from , state) do
  # IO.puts("fgv")
  len = 0
  prefix_match_list = []
  match_list = Enum.filter( list_nodes , fn x ->

  node1 = GenServer.call( x , {:gethash} )
  node2 = new_node
  prefix_match_len = prefix_match(node1,node2,0)
  if prefix_match_len == len do
    x
  end
  if prefix_match_len > len do
    len = prefix_match_len
    x
  end
end)

dist = Enum.map( match_list, fn x ->
  x_hash = GenServer.call( x , {:gethash} )
  GenServer.cast( x , {:updatetable, x_hash , new_node } )
  dist = prefix_match(x_hash,new_node,0)
end)

if Enum.empty?(dist)==false do
max_prefix = Enum.max(dist)
idx = Enum.find_index( dist , fn x -> x == max_prefix end)
max_prefix_pid = Enum.at(match_list, idx)
{:reply,[max_prefix_pid,max_prefix], state}
else
  {:reply,[0,0], state}
end
end

def handle_cast( {:updatert, node2, max_prefix}, state) do
  # IO.puts("in update rt")
  routing_table = Map.get(state, :routingtable)
  node1 = Map.get(state, :node_id)
  current_state = :sys.get_state(node2)
  current_rt = Map.get(current_state, :routingtable)
  node = Map.get(current_state, :node_id)

  Enum.each( 1..max_prefix, fn x ->
    c_routingtable = Map.get(current_state, :routingtable)
    GenServer.cast( self() , {:updatel , c_routingtable , x} ) end)
{:noreply,state}


end

def handle_cast({:updatel, c_routingtable, x} , state) do
  # IO.puts("In updatel")
  routingtable = Map.get(state, :routingtable)
  # IO.inspect(routingtable)
  list = Enum.at(c_routingtable, x)
   # IO.inspect list
  routingtable = List.replace_at( routingtable , x , list)
  # IO.inspect(routingtable)
  state = Map.put(state, :routingtable, routingtable)
  {:noreply,state}
end

def handle_cast({:routing,list_nodes, numRequests, nodes_hash}, state) do
  # IO.puts("routing")
  temp = List.delete(list_nodes, self())
  node1 = Map.get(state, :node_id)
  thash = List.delete(nodes_hash, node1)

  Enum.each(1..numRequests, fn x->
    dest = Enum.random(temp)
    index = Enum.find_index(temp, fn y-> dest == y end)
    dest_hash = Enum.at(thash, index)
    GenServer.cast( self() , {:sendRequest, dest_hash , 0} ) end)
    {:noreply, state}
end

def handle_call({:filltable, allNodes}, _from, state) do
  node1 = Map.get(state, :node_id)

  Enum.each( allNodes, fn x ->
    x_hash = GenServer.call( x , {:gethash} )
    dist = prefix_match( node1, x_hash , 0 )
  if dist == 0 do
      GenServer.cast( self() , {:updatefill0 , node1 , x_hash} )
  end end)
  {:reply, node1, state}
end

  def handle_cast( {:updatefill0 , nodeA , nodeB }, state ) do
  i = prefix_match( nodeA, nodeB , 0 )
  val = String.at(nodeB,i)
  j = cond do
      val == "A" -> 10
      val == "B" -> 11
      val == "C" -> 12
      val == "D" -> 13
      val == "E" -> 14
      val == "F" -> 15
      true -> String.to_integer(val)
  end
    routingtable = Map.get(state, :routingtable)
    list = Enum.at(routingtable, i)
    list = List.replace_at( list , j , nodeB )
    routingtable = List.replace_at(routingtable, i, list)

    # IO.inspect routingtable
    state = Map.put(state, :routingtable, routingtable)
    {:noreply,state}
  end

def handle_cast( {:sendRequest, dest , hops} , state ) do
   # IO.puts("In Send Request")
  routingtable = Map.get(state , :routingtable)
  nodeid = Map.get(state, :node_id)
  match = prefix_match( nodeid, dest , 0 )
  val = String.at(dest, match)

  y_val = cond do
    val == "A" -> 10
    val == "B" -> 11
    val == "C" -> 12
    val == "D" -> 13
    val == "E" -> 14
    val == "F" -> 15
    true -> String.to_integer(val)
end

list = Enum.at(routingtable, match)
r_node = Enum.at(list , y_val)

if r_node != 0 do
r_pid = Process.whereis( String.to_atom(r_node) )

:timer.sleep(10)
GenServer.cast( r_pid , {:nexthop , dest, hops+1} )

else
  pid=:global.whereis_name(:tapestry)
  Process.send_after( pid, {:catchhops , hops} ,0)
  end
  {:noreply, state}
end

  def handle_cast( {:nexthop ,dest, hops} ,state) do
     # IO.puts(":Next hp")
    routingtable = Map.get(state , :routingtable)
    nodeid = Map.get(state, :node_id)
    dist = prefix_match( nodeid, dest , 0 )

    if dist == 8 do
      pid=:global.whereis_name(:tapestry)
      Process.send_after( pid ,{:catchhops , hops} ,0)
      {:noreply, state}
    else
      # IO.puts("FDVFVFV")
      val = String.at(dest, dist)
      j = cond do
          val == "A" -> 10
          val == "B" -> 11
          val == "C" -> 12
          val == "D" -> 13
          val == "E" -> 14
          val == "F" -> 15
          true -> String.to_integer(val)
  end

      list = Enum.at(routingtable, dist)
      r_node = Enum.at(list , j)

    if r_node != 0 do
      r_pid = Process.whereis( String.to_atom(r_node) )
      # IO.inspect(r_pid)
      GenServer.cast( r_pid , {:nexthop , dest, hops+1} )

    else
      pid=:global.whereis_name(:tapestry)
      Process.send_after( pid ,{:catchhops , hops} ,0)
    end
  end
  {:noreply,state}
end


end
