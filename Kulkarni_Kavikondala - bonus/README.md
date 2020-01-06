


# README - Project 2

## Team Members

 1. Bharat Kulkarni - 5689-3029
 2. Megha Sai Kavikondala - 4754-3974 
 


##  What is working
Gossip and Pushsum Protocols work on all the topologies.
List of topologies;
1. Line
2. Full
3. Random 2D
4. Honeycomb
5. Random Honeycomb
6. 3D Torus

## Steps for Code Execution
1. Unzip "DOS_Project2"
2. Go to "Project2" file.
3. In the terminal run,
4. Topologies: (line, full, rand2D, 3Dtorus, honeycomb, randhoneycomb)
5. Algorithms: (gossip, pushsum)

mix run project2.exs numNodes topology algorithm

  Example,
	`mix run project2.exs 500 rand2D gossip`
	


## What is the largest network you managed to deal with for each type of topology and algorithm
|Topologies  | Gossip Protocol | Pushsum Protocol  |
|--|--|--|
| Line | 6000 | 800 |
|  Full| 3000 |1200  |
| Random 2D | 11000  |  8000|
| Honeycomb | 8000 | 8000 |
| Random Honeycomb |12000|  9000|
| 3D Torus | 7000  |  4000|

## Sample Output


    >mix run project2.exs 50 3Dtorus gossip
    Converged node #PID<0.200.0>
    Converged node #PID<0.251.0>
    Converged node #PID<0.205.0>
    Converged node #PID<0.225.0>
    Converged node #PID<0.239.0>
    Converged node #PID<0.216.0>
    Converged node #PID<0.249.0>
    Converged node #PID<0.210.0>
    Converged node #PID<0.242.0>
    Converged node #PID<0.198.0>
    Converged node #PID<0.248.0>
    Converged node #PID<0.241.0>
    Converged node #PID<0.196.0>
    Converged node #PID<0.246.0>
    Converged node #PID<0.218.0>
    Converged node #PID<0.244.0>
    Converged node #PID<0.252.0>
    Converged node #PID<0.211.0>
    Converged node #PID<0.238.0>
    Converged node #PID<0.232.0>
    Converged node #PID<0.212.0>
    Converged node #PID<0.237.0>
    Converged node #PID<0.199.0>
    Converged node #PID<0.201.0>
    Converged node #PID<0.228.0>
    Converged node #PID<0.207.0>
    Converged node #PID<0.209.0>
    Converged node #PID<0.190.0>
    Converged node #PID<0.224.0>
    Converged node #PID<0.243.0>
    Converged node #PID<0.214.0>
    Converged node #PID<0.220.0>
    Converged node #PID<0.247.0>
    Converged node #PID<0.245.0>
    Converged node #PID<0.221.0>
    Converged node #PID<0.203.0>
    Converged node #PID<0.231.0>
    Converged node #PID<0.223.0>
    Converged node #PID<0.202.0>
    Converged node #PID<0.197.0>
    Converged node #PID<0.250.0>
    Converged node #PID<0.192.0>
    Converged node #PID<0.229.0>
    Converged node #PID<0.234.0>
    Converged node #PID<0.226.0>
    Converged node #PID<0.195.0>
    Converged node #PID<0.236.0>
    Converged node #PID<0.204.0>
    Converged node #PID<0.217.0>
    Converged node #PID<0.233.0>
    Time required to achieve convergence: 1640 milliseconds







