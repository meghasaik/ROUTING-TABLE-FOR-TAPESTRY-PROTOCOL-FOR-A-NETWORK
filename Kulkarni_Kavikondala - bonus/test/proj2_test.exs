defmodule Proj2Test do
  use ExUnit.Case
  doctest Proj2

  test "greets the world" do
    Proj2.main()
    # Registry.start_link(keys: :unique, name: :registry)
    # Pushsum.start(10,'full')
    # IO.inspect NeighborFactory.impLineNeighbor(1,10)
    # range = 1..100
    # random2dGrid = Enum.shuffle(range) |> Enum.with_index(1)
    # IO.inspect NeighborFactory.rand2DNeighbor(25,100,random2dGrid)
  end
end
