# CS-300 Kotlin Graph Algorithms Examples

## 🎯 Purpose
Demonstrate graph algorithms implementation in Kotlin including traversal, shortest path, and minimum spanning tree algorithms.

## 📝 Kotlin Graph Algorithm Examples

### Graph Representation
```kotlin
// Adjacency List representation
class Graph(private val vertices: Int) {
    private val adjList = Array(vertices) { mutableListOf<Int>() }
    
    fun addEdge(source: Int, destination: Int) {
        adjList[source].add(destination)
        // For undirected graph, uncomment the next line
        // adjList[destination].add(source)
    }
    
    fun getNeighbors(vertex: Int): List<Int> {
        return adjList[vertex]
    }
    
    fun getVertices(): Int = vertices
    
    fun printGraph() {
        for (i in 0 until vertices) {
            print("Vertex $i: ")
            for (neighbor in adjList[i]) {
                print("$neighbor ")
            }
            println()
        }
    }
}

// Weighted Graph representation
class WeightedGraph(private val vertices: Int) {
    private val adjList = Array(vertices) { mutableListOf<Pair<Int, Int>>() }
    
    fun addEdge(source: Int, destination: Int, weight: Int) {
        adjList[source].add(Pair(destination, weight))
        // For undirected graph, uncomment the next line
        // adjList[destination].add(Pair(source, weight))
    }
    
    fun getNeighbors(vertex: Int): List<Pair<Int, Int>> {
        return adjList[vertex]
    }
    
    fun getVertices(): Int = vertices
}
```

### Depth-First Search (DFS)
```kotlin
class GraphTraversal {
    // Recursive DFS
    fun dfsRecursive(graph: Graph, startVertex: Int): List<Int> {
        val visited = BooleanArray(graph.getVertices())
        val result = mutableListOf<Int>()
        
        fun dfs(vertex: Int) {
            visited[vertex] = true
            result.add(vertex)
            
            for (neighbor in graph.getNeighbors(vertex)) {
                if (!visited[neighbor]) {
                    dfs(neighbor)
                }
            }
        }
        
        dfs(startVertex)
        return result
    }
    
    // Iterative DFS using stack
    fun dfsIterative(graph: Graph, startVertex: Int): List<Int> {
        val visited = BooleanArray(graph.getVertices())
        val result = mutableListOf<Int>()
        val stack = java.util.Stack<Int>()
        
        stack.push(startVertex)
        
        while (stack.isNotEmpty()) {
            val vertex = stack.pop()
            
            if (!visited[vertex]) {
                visited[vertex] = true
                result.add(vertex)
                
                // Add neighbors in reverse order to maintain left-to-right traversal
                for (neighbor in graph.getNeighbors(vertex).reversed()) {
                    if (!visited[neighbor]) {
                        stack.push(neighbor)
                    }
                }
            }
        }
        
        return result
    }
    
    // DFS for finding connected components
    fun findConnectedComponents(graph: Graph): List<List<Int>> {
        val visited = BooleanArray(graph.getVertices())
        val components = mutableListOf<List<Int>>()
        
        fun dfs(vertex: Int, component: MutableList<Int>) {
            visited[vertex] = true
            component.add(vertex)
            
            for (neighbor in graph.getNeighbors(vertex)) {
                if (!visited[neighbor]) {
                    dfs(neighbor, component)
                }
            }
        }
        
        for (i in 0 until graph.getVertices()) {
            if (!visited[i]) {
                val component = mutableListOf<Int>()
                dfs(i, component)
                components.add(component)
            }
        }
        
        return components
    }
}
```

### Breadth-First Search (BFS)
```kotlin
class BFSAlgorithms {
    // Basic BFS
    fun bfs(graph: Graph, startVertex: Int): List<Int> {
        val visited = BooleanArray(graph.getVertices())
        val result = mutableListOf<Int>()
        val queue = java.util.ArrayDeque<Int>()
        
        visited[startVertex] = true
        queue.offer(startVertex)
        
        while (queue.isNotEmpty()) {
            val vertex = queue.poll()
            result.add(vertex)
            
            for (neighbor in graph.getNeighbors(vertex)) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true
                    queue.offer(neighbor)
                }
            }
        }
        
        return result
    }
    
    // BFS with distance calculation
    fun bfsWithDistance(graph: Graph, startVertex: Int): Map<Int, Int> {
        val visited = BooleanArray(graph.getVertices())
        val distances = mutableMapOf<Int, Int>()
        val queue = java.util.ArrayDeque<Int>()
        
        visited[startVertex] = true
        distances[startVertex] = 0
        queue.offer(startVertex)
        
        while (queue.isNotEmpty()) {
            val vertex = queue.poll()
            
            for (neighbor in graph.getNeighbors(vertex)) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true
                    distances[neighbor] = distances[vertex]!! + 1
                    queue.offer(neighbor)
                }
            }
        }
        
        return distances
    }
    
    // Shortest path using BFS
    fun shortestPath(graph: Graph, start: Int, end: Int): List<Int>? {
        val visited = BooleanArray(graph.getVertices())
        val parent = IntArray(graph.getVertices()) { -1 }
        val queue = java.util.ArrayDeque<Int>()
        
        visited[start] = true
        queue.offer(start)
        
        while (queue.isNotEmpty()) {
            val vertex = queue.poll()
            
            if (vertex == end) {
                // Reconstruct path
                val path = mutableListOf<Int>()
                var current = end
                while (current != -1) {
                    path.add(current)
                    current = parent[current]
                }
                return path.reversed()
            }
            
            for (neighbor in graph.getNeighbors(vertex)) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true
                    parent[neighbor] = vertex
                    queue.offer(neighbor)
                }
            }
        }
        
        return null // No path found
    }
}
```

### Dijkstra's Algorithm (Shortest Path)
```kotlin
class DijkstraAlgorithm {
    data class Edge(val destination: Int, val weight: Int)
    data class Vertex(val id: Int, val distance: Int) : Comparable<Vertex> {
        override fun compareTo(other: Vertex): Int = distance.compareTo(other.distance)
    }
    
    fun dijkstra(graph: WeightedGraph, start: Int): IntArray {
        val distances = IntArray(graph.getVertices()) { Int.MAX_VALUE }
        val visited = BooleanArray(graph.getVertices())
        val pq = java.util.PriorityQueue<Vertex>()
        
        distances[start] = 0
        pq.offer(Vertex(start, 0))
        
        while (pq.isNotEmpty()) {
            val current = pq.poll()
            val vertex = current.id
            
            if (visited[vertex]) continue
            visited[vertex] = true
            
            for ((neighbor, weight) in graph.getNeighbors(vertex)) {
                val newDistance = distances[vertex] + weight
                
                if (newDistance < distances[neighbor]) {
                    distances[neighbor] = newDistance
                    pq.offer(Vertex(neighbor, newDistance))
                }
            }
        }
        
        return distances
    }
    
    fun dijkstraWithPath(graph: WeightedGraph, start: Int, end: Int): Pair<Int, List<Int>>? {
        val distances = IntArray(graph.getVertices()) { Int.MAX_VALUE }
        val parent = IntArray(graph.getVertices()) { -1 }
        val visited = BooleanArray(graph.getVertices())
        val pq = java.util.PriorityQueue<Vertex>()
        
        distances[start] = 0
        pq.offer(Vertex(start, 0))
        
        while (pq.isNotEmpty()) {
            val current = pq.poll()
            val vertex = current.id
            
            if (visited[vertex]) continue
            visited[vertex] = true
            
            if (vertex == end) {
                // Reconstruct path
                val path = mutableListOf<Int>()
                var current = end
                while (current != -1) {
                    path.add(current)
                    current = parent[current]
                }
                return Pair(distances[end], path.reversed())
            }
            
            for ((neighbor, weight) in graph.getNeighbors(vertex)) {
                val newDistance = distances[vertex] + weight
                
                if (newDistance < distances[neighbor]) {
                    distances[neighbor] = newDistance
                    parent[neighbor] = vertex
                    pq.offer(Vertex(neighbor, newDistance))
                }
            }
        }
        
        return null // No path found
    }
}
```

### Bellman-Ford Algorithm
```kotlin
class BellmanFordAlgorithm {
    data class Edge(val source: Int, val destination: Int, val weight: Int)
    
    fun bellmanFord(edges: List<Edge>, vertices: Int, start: Int): IntArray? {
        val distances = IntArray(vertices) { Int.MAX_VALUE }
        distances[start] = 0
        
        // Relax edges V-1 times
        repeat(vertices - 1) {
            for (edge in edges) {
                if (distances[edge.source] != Int.MAX_VALUE) {
                    val newDistance = distances[edge.source] + edge.weight
                    if (newDistance < distances[edge.destination]) {
                        distances[edge.destination] = newDistance
                    }
                }
            }
        }
        
        // Check for negative cycles
        for (edge in edges) {
            if (distances[edge.source] != Int.MAX_VALUE) {
                val newDistance = distances[edge.source] + edge.weight
                if (newDistance < distances[edge.destination]) {
                    return null // Negative cycle detected
                }
            }
        }
        
        return distances
    }
}
```

### Floyd-Warshall Algorithm (All Pairs Shortest Path)
```kotlin
class FloydWarshallAlgorithm {
    fun floydWarshall(graph: Array<IntArray>): Array<IntArray> {
        val n = graph.size
        val dist = Array(n) { i -> graph[i].copyOf() }
        
        // Initialize diagonal to 0
        for (i in 0 until n) {
            dist[i][i] = 0
        }
        
        // Floyd-Warshall algorithm
        for (k in 0 until n) {
            for (i in 0 until n) {
                for (j in 0 until n) {
                    if (dist[i][k] != Int.MAX_VALUE && dist[k][j] != Int.MAX_VALUE) {
                        dist[i][j] = minOf(dist[i][j], dist[i][k] + dist[k][j])
                    }
                }
            }
        }
        
        return dist
    }
    
    fun hasNegativeCycle(dist: Array<IntArray>): Boolean {
        for (i in dist.indices) {
            if (dist[i][i] < 0) {
                return true
            }
        }
        return false
    }
}
```

### Minimum Spanning Tree - Kruskal's Algorithm
```kotlin
class KruskalAlgorithm {
    data class Edge(val source: Int, val destination: Int, val weight: Int) : Comparable<Edge> {
        override fun compareTo(other: Edge): Int = weight.compareTo(other.weight)
    }
    
    class UnionFind(private val n: Int) {
        private val parent = IntArray(n) { it }
        private val rank = IntArray(n) { 0 }
        
        fun find(x: Int): Int {
            if (parent[x] != x) {
                parent[x] = find(parent[x]) // Path compression
            }
            return parent[x]
        }
        
        fun union(x: Int, y: Int): Boolean {
            val rootX = find(x)
            val rootY = find(y)
            
            if (rootX == rootY) return false
            
            // Union by rank
            when {
                rank[rootX] < rank[rootY] -> parent[rootX] = rootY
                rank[rootX] > rank[rootY] -> parent[rootY] = rootX
                else -> {
                    parent[rootY] = rootX
                    rank[rootX]++
                }
            }
            
            return true
        }
    }
    
    fun kruskal(edges: List<Edge>, vertices: Int): List<Edge> {
        val sortedEdges = edges.sorted()
        val mst = mutableListOf<Edge>()
        val uf = UnionFind(vertices)
        
        for (edge in sortedEdges) {
            if (uf.union(edge.source, edge.destination)) {
                mst.add(edge)
                if (mst.size == vertices - 1) break
            }
        }
        
        return mst
    }
    
    fun getMSTWeight(mst: List<Edge>): Int {
        return mst.sumOf { it.weight }
    }
}
```

### Minimum Spanning Tree - Prim's Algorithm
```kotlin
class PrimAlgorithm {
    data class Edge(val destination: Int, val weight: Int) : Comparable<Edge> {
        override fun compareTo(other: Edge): Int = weight.compareTo(other.weight)
    }
    
    fun prim(graph: WeightedGraph, start: Int): List<Pair<Int, Int>> {
        val mst = mutableListOf<Pair<Int, Int>>()
        val visited = BooleanArray(graph.getVertices())
        val pq = java.util.PriorityQueue<Edge>()
        
        visited[start] = true
        
        // Add all edges from start vertex
        for ((neighbor, weight) in graph.getNeighbors(start)) {
            pq.offer(Edge(neighbor, weight))
        }
        
        while (pq.isNotEmpty() && mst.size < graph.getVertices() - 1) {
            val edge = pq.poll()
            val destination = edge.destination
            
            if (!visited[destination]) {
                visited[destination] = true
                mst.add(Pair(start, destination)) // Simplified for demo
                
                // Add all edges from new vertex
                for ((neighbor, weight) in graph.getNeighbors(destination)) {
                    if (!visited[neighbor]) {
                        pq.offer(Edge(neighbor, weight))
                    }
                }
            }
        }
        
        return mst
    }
}
```

### Topological Sort
```kotlin
class TopologicalSort {
    fun topologicalSort(graph: Graph): List<Int> {
        val visited = BooleanArray(graph.getVertices())
        val stack = java.util.Stack<Int>()
        
        fun dfs(vertex: Int) {
            visited[vertex] = true
            
            for (neighbor in graph.getNeighbors(vertex)) {
                if (!visited[neighbor]) {
                    dfs(neighbor)
                }
            }
            
            stack.push(vertex)
        }
        
        for (i in 0 until graph.getVertices()) {
            if (!visited[i]) {
                dfs(i)
            }
        }
        
        return stack.toList().reversed()
    }
    
    fun hasCycle(graph: Graph): Boolean {
        val color = IntArray(graph.getVertices()) // 0: white, 1: gray, 2: black
        
        fun dfs(vertex: Int): Boolean {
            color[vertex] = 1 // Gray
            
            for (neighbor in graph.getNeighbors(vertex)) {
                when (color[neighbor]) {
                    1 -> return true // Back edge found (cycle)
                    0 -> if (dfs(neighbor)) return true
                }
            }
            
            color[vertex] = 2 // Black
            return false
        }
        
        for (i in 0 until graph.getVertices()) {
            if (color[i] == 0 && dfs(i)) {
                return true
            }
        }
        
        return false
    }
}
```

### Performance Testing
```kotlin
fun main() {
    // Create a sample graph
    val graph = Graph(6)
    graph.addEdge(0, 1)
    graph.addEdge(0, 2)
    graph.addEdge(1, 3)
    graph.addEdge(2, 3)
    graph.addEdge(3, 4)
    graph.addEdge(4, 5)
    
    println("Graph structure:")
    graph.printGraph()
    
    // Test DFS
    val traversal = GraphTraversal()
    println("\nDFS (recursive): ${traversal.dfsRecursive(graph, 0)}")
    println("DFS (iterative): ${traversal.dfsIterative(graph, 0)}")
    println("Connected components: ${traversal.findConnectedComponents(graph)}")
    
    // Test BFS
    val bfs = BFSAlgorithms()
    println("\nBFS: ${bfs.bfs(graph, 0)}")
    println("BFS distances: ${bfs.bfsWithDistance(graph, 0)}")
    println("Shortest path (0 to 5): ${bfs.shortestPath(graph, 0, 5)}")
    
    // Test Dijkstra's algorithm
    val weightedGraph = WeightedGraph(6)
    weightedGraph.addEdge(0, 1, 4)
    weightedGraph.addEdge(0, 2, 2)
    weightedGraph.addEdge(1, 3, 5)
    weightedGraph.addEdge(2, 3, 8)
    weightedGraph.addEdge(3, 4, 6)
    weightedGraph.addEdge(4, 5, 1)
    
    val dijkstra = DijkstraAlgorithm()
    val distances = dijkstra.dijkstra(weightedGraph, 0)
    println("\nDijkstra distances from 0: ${distances.joinToString()}")
    
    val pathResult = dijkstra.dijkstraWithPath(weightedGraph, 0, 5)
    if (pathResult != null) {
        println("Shortest path (0 to 5): ${pathResult.second} with distance ${pathResult.first}")
    }
    
    // Test Kruskal's algorithm
    val edges = listOf(
        KruskalAlgorithm.Edge(0, 1, 4),
        KruskalAlgorithm.Edge(0, 2, 2),
        KruskalAlgorithm.Edge(1, 3, 5),
        KruskalAlgorithm.Edge(2, 3, 8),
        KruskalAlgorithm.Edge(3, 4, 6),
        KruskalAlgorithm.Edge(4, 5, 1)
    )
    
    val kruskal = KruskalAlgorithm()
    val mst = kruskal.kruskal(edges, 6)
    println("\nMST edges: $mst")
    println("MST weight: ${kruskal.getMSTWeight(mst)}")
    
    // Test Topological Sort
    val dag = Graph(6)
    dag.addEdge(5, 2)
    dag.addEdge(5, 0)
    dag.addEdge(4, 0)
    dag.addEdge(4, 1)
    dag.addEdge(2, 3)
    dag.addEdge(3, 1)
    
    val topo = TopologicalSort()
    println("\nTopological sort: ${topo.topologicalSort(dag)}")
    println("Has cycle: ${topo.hasCycle(dag)}")
}
```

## 🔍 Graph Algorithm Complexity

| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|----------------|------------------|-------|
| DFS/BFS | O(V + E) | O(V) | V = vertices, E = edges |
| Dijkstra | O((V + E) log V) | O(V) | With priority queue |
| Bellman-Ford | O(VE) | O(V) | Handles negative weights |
| Floyd-Warshall | O(V³) | O(V²) | All pairs shortest path |
| Kruskal's MST | O(E log E) | O(V) | Union-Find data structure |
| Prim's MST | O((V + E) log V) | O(V) | With priority queue |
| Topological Sort | O(V + E) | O(V) | DFS-based |

## 💡 Learning Points
- **Graph representation** affects algorithm efficiency
- **DFS** explores as far as possible before backtracking
- **BFS** explores level by level, finds shortest path in unweighted graphs
- **Dijkstra's algorithm** finds shortest path in weighted graphs
- **Bellman-Ford** handles negative weights and detects negative cycles
- **Floyd-Warshall** computes all pairs shortest paths
- **MST algorithms** find minimum cost to connect all vertices
- **Topological sort** orders vertices in directed acyclic graphs
- **Union-Find** efficiently manages disjoint sets
- **Priority queues** optimize many graph algorithms
