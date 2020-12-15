"""
gen_graph(df::DataFrame)
Generate a simple weighted graph from a DataFrame.
The DataFrame must be an Adjecency matrix.

Return (g,ew)
* g  - is a SimpleWeightedGraph()
* ew - is an Array containing the weights for each edge
"""
function gen_graph(df)
    g = SimpleWeightedGraph(size(df)[2])
    ew = Int[]
    pairings = [] 
    
    # iterate over all combinations of columns
    for i in 1:size(df)[2], j in i+1:size(df)[2]

      # calculate how many times (i,j) occurs
      w = dot(df[:, i], df[:, j])

      if w > 0
            push!(ew, w)
            LightGraphs.add_edge!(g, i, j, w)
            push!(pairings,[i,j])
        end

    end
    return (g,ew)
end


"""
get_edges(g,node_x,node_y)
g is a SimpleWeightedGraph, while node_x and node_y are
arrays containing the position of the nodes.

Return a DataFrame containing the edge information,
such as position, pairs and weights.
"""
function get_edges(g,node_x,node_y)
    edges_p1 = []
    edges_p2 = []
    edges_w  = Float64[]
    for i in edges(g)
        push!(edges_p1, i.src)
        push!(edges_p1, i.src)
        push!(edges_p2, i.dst)
        push!(edges_p2, i.dst)
        push!(edges_w, i.weight)
        push!(edges_w, i.weight)
    end
    
    edges_node  = Int[]
    edges_pairs = []
    for i in 1:size(edges_p1)[1]
        if i % 2 == 0
            push!(edges_node,edges_p2[i])
        else
            push!(edges_node,edges_p1[i])
        end
        push!(edges_pairs,[edges_p1[i],edges_p2[i]])
    end 
    graph_edges = DataFrames.DataFrame(edges_x = node_x[edges_node], edges_y = node_y[edges_node],
                       pairs = edges_pairs, ew = edges_w, node = edges_node) 
    return graph_edges
  end
