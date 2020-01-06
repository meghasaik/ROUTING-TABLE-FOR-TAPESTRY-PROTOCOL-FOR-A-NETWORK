defmodule Project3 do
  if length(System.argv) != 2 do
      IO.puts("Provide all arguments")
  end

 [numNodes,numRequests] = System.argv()
 Tapestry.main(String.to_integer(numNodes), String.to_integer(numRequests))
   
end
