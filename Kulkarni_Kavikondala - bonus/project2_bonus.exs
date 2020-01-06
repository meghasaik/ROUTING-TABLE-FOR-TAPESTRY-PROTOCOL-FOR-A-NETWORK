defmodule Project2 do

  # l = length(System.argv)
  # IO.puts("#{l}")
   if length(System.argv) != 4 do
     IO.puts("Please provide all required arguments")
     System.halt(0)
   end


[numNodes, topology, algo, perc_faulty_nodes] = System.argv()
  Proj2.main(String.to_integer(numNodes), topology, algo, String.to_integer(perc_faulty_nodes))
end
