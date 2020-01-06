defmodule Topologies do
  def getNeighbor(list_nodes, i, numNodes, topology, random2dGrid) do
    range = 1..numNodes

    case topology do
      "full" -> Enum.reject(range, fn x -> x == i end)
      "line" -> Enum.filter(range, fn x -> x == i + 1 || x == i - 1 end)
      "rand2D" -> rand2DNeighbor(i, numNodes, random2dGrid)
       "3Dtorus" ->  get3DTorusNeighbor(list_nodes, i, numNodes)
      "honeycomb" -> getHoneycombNeighbor(list_nodes, i, numNodes)
      "randhoneycomb" -> getRandomHoneycombNeighbor(list_nodes, i , numNodes)
    end
end

 defp getHoneycombNeighbor(_list_nodes, i , numNodes) do
   w = numNodes |> :math.pow(1/2) |> :math.ceil()
  nth_row = i/w |> :math.floor()


  cond do

          :math.fmod(nth_row,2) == 0 ->   # for even^th row/bucket
          cond do

              :math.fmod(i,2) == 0 -> # for even^th element in row/bucket
                # IO.puts("EE")
                neighbor1 = i - 1
                neighbor2 = i + w
                neighbor3 = i - w
                list_neighbors = [neighbor1,neighbor2, neighbor3]
                list_neighbors  |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)


              :math.fmod(i,2) == 1 ->
              # IO.puts("EO")
              neighbor1 = i - 1
              neighbor2 = i + w
              neighbor3 = i - w
              list_neighbors = [neighbor1,neighbor2, neighbor3]
              list_neighbors  |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)

         end

        :math.fmod(nth_row,2) == 1 ->   # for odd^th row/bucket
        cond do
            :math.fmod(i,2) == 0 -> # for even^th element in odd^th row/bucket
              # IO.puts("OE")
              neighbor1 = i + 1
              neighbor2 = i + w
              neighbor3 = i - w
              list_neighbors = [neighbor1,neighbor2, neighbor3]
              list_neighbors  |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)


            :math.fmod(i,2) == 1 ->  # for odd^th element in odd^th row
              # IO.puts("OO")
              neighbor1 = i - 1
              neighbor2 = i + w
              neighbor3 = i - w
              list_neighbors = [neighbor1,neighbor2, neighbor3]
              list_neighbors  |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)

        end
  end
end


defp getRandomHoneycombNeighbor(list_nodes, i , numNodes) do
  w = numNodes |> :math.pow(1/2) |> :math.ceil()
 nth_row = i/w |> :math.floor()


 cond do

         :math.fmod(nth_row,2) == 0 ->   # for even^th row/bucket
         cond do

             :math.fmod(i,2) == 0 -> # for even^th element in row/bucket
               # IO.puts("EE")
               neighbor1 = i - 1
               neighbor2 = i + w
               neighbor3 = i - w
               neighbor4 = Enum.random(list_nodes)
               list_neighbors = [neighbor1,neighbor2, neighbor3, neighbor4]
               list_neighbors  |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)


             :math.fmod(i,2) == 1 ->   # for odd element in row/bucket
               # IO.puts("EO")
               neighbor1 = i - 1
               neighbor2 = i + w
               neighbor3 = i - w
               neighbor4 = Enum.random(list_nodes)
               list_neighbors = [neighbor1,neighbor2, neighbor3, neighbor4]
               list_neighbors  |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)

        end

       :math.fmod(nth_row,2) == 1 ->   # for odd^th row/bucket
       cond do
           :math.fmod(i,2) == 0 -> # for even^th element in odd^th row/bucket
             # IO.puts("OE")
             neighbor1 = i + 1
             neighbor2 = i + w
             neighbor3 = i - w
              neighbor4 = Enum.random(list_nodes)
             list_neighbors = [neighbor1,neighbor2, neighbor3, neighbor4]
             list_neighbors  |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)


           :math.fmod(i,2) == 1 ->  # for odd^th element in odd^th row
             # IO.puts("OO")
             neighbor1 = i - 1
             neighbor2 = i + w
             neighbor3 = i - w
             neighbor4 = Enum.random(list_nodes)
             list_neighbors = [neighbor1,neighbor2, neighbor3, neighbor4]
             list_neighbors  |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)

       end
 end
end

def get3DTorusNeighbor(list_nodes, i , numNodes) do

  rowNodeCount = round(Float.ceil(:math.pow(numNodes,(1/3))))
  planeNodeCount = round(:math.pow(rowNodeCount,2))

  numNodes = :math.pow(rowNodeCount,3)

  positiveX = if(i+1 <= numNodes && rem(i,rowNodeCount) != 0) do i+1 else i - rowNodeCount + 1 end
  negativeX = if(i-1 >= 1 && rem(i-1,rowNodeCount) != 0) do i-1 else i+rowNodeCount-1 end
  positiveY = if(rem(i,planeNodeCount) != 0 && planeNodeCount - rowNodeCount >= rem(i,(planeNodeCount))) do i+ rowNodeCount else i-planeNodeCount+rowNodeCount end
  negativeY = if((planeNodeCount - rowNodeCount*(rowNodeCount-1)) < rem(i-1,(planeNodeCount)) + 1) do i- rowNodeCount else i+planeNodeCount-rowNodeCount end
  positiveZ = if(i+ planeNodeCount <= numNodes) do i + planeNodeCount else i - planeNodeCount*(rowNodeCount-1) end
  negativeZ = if(i- planeNodeCount >= 1) do i- planeNodeCount else i + planeNodeCount*(rowNodeCount-1) end

  list_neighbors = [
    Enum.at(list_nodes, positiveX-1) ,
    Enum.at(list_nodes, negativeX-1) ,
    Enum.at(list_nodes, positiveY-1) ,
    Enum.at(list_nodes, negativeY-1) ,
    Enum.at(list_nodes, positiveZ-1) ,
    Enum.at(list_nodes, negativeZ-1) ]

    list_neighbors |> Enum.filter( fn x -> x != nil  && x > 0 && x < numNodes end) |> Enum.map(fn x-> trunc(x) end)
    #IO.inspect(list_neighbors)


end

  def rand2DNeighbor(i, numNodes, random2dGrid) do
    gridLen = numNodes |> :math.sqrt() |> trunc()
    k = (gridLen / 10) |> :math.ceil() |> trunc()

    top = Enum.map(1..k, fn x -> i - x * gridLen end) |> Enum.filter(fn x -> x > 0 end)
    bottom = Enum.map(1..k, fn x -> i + x * gridLen end) |> Enum.filter(fn x -> x <= numNodes end)

    right =
      if rem(i, gridLen) == 0,
        do: [],
        else: Enum.take_while((i + 1)..(i + k), fn x -> rem(x, gridLen) != 1 end)

    left =
      if rem(i, gridLen) == 1,
        do: [],
        else: Enum.take_while((i - 1)..(i - k), fn x -> rem(x, gridLen) != 0 end)

    neighborIndex = top ++ bottom ++ right ++ left |> Enum.map(fn x -> trunc(x) end)

    Enum.filter(random2dGrid, fn x -> Enum.member?(neighborIndex, elem(x, 1)) end)
    |> Enum.map(fn x -> elem(x, 0) end)
  end

  def correctNumNodesForGrids(numNodes, topology) do
    case topology do
       "3Dtorus" -> :math.pow(numNodes, 1 / 3) |> :math.ceil() |> :math.pow(3) |> trunc()
      "rand2D" -> :math.sqrt(numNodes) |> :math.ceil() |> :math.pow(2) |> trunc()
      "honeycomb" -> :math.sqrt(numNodes) |> :math.ceil() |> :math.pow(2) |> trunc()
      "randhoneycomb" -> :math.sqrt(numNodes) |> :math.ceil() |> :math.pow(2) |> trunc()
      _ -> numNodes
    end
  end
end
