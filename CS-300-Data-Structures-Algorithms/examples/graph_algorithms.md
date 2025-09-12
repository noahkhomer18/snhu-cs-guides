# CS-300 Graph Algorithms

## 🎯 Purpose
Demonstrate advanced graph algorithms and data structures for complex problem solving.

## 📝 Graph Algorithm Examples

### Graph Representation
```java
import java.util.*;

class Graph {
    private int vertices;
    private List<List<Integer>> adjacencyList;
    
    public Graph(int vertices) {
        this.vertices = vertices;
        this.adjacencyList = new ArrayList<>();
        for (int i = 0; i < vertices; i++) {
            adjacencyList.add(new ArrayList<>());
        }
    }
    
    public void addEdge(int source, int destination) {
        adjacencyList.get(source).add(destination);
        adjacencyList.get(destination).add(source); // For undirected graph
    }
    
    public List<Integer> getNeighbors(int vertex) {
        return adjacencyList.get(vertex);
    }
    
    public int getVertices() {
        return vertices;
    }
}
```

### Depth-First Search (DFS)
```java
public class GraphTraversal {
    
    // Recursive DFS
    public static void dfsRecursive(Graph graph, int start, boolean[] visited) {
        visited[start] = true;
        System.out.print(start + " ");
        
        for (int neighbor : graph.getNeighbors(start)) {
            if (!visited[neighbor]) {
                dfsRecursive(graph, neighbor, visited);
            }
        }
    }
    
    // Iterative DFS using stack
    public static void dfsIterative(Graph graph, int start) {
        boolean[] visited = new boolean[graph.getVertices()];
        Stack<Integer> stack = new Stack<>();
        
        stack.push(start);
        
        while (!stack.isEmpty()) {
            int current = stack.pop();
            
            if (!visited[current]) {
                visited[current] = true;
                System.out.print(current + " ");
                
                for (int neighbor : graph.getNeighbors(current)) {
                    if (!visited[neighbor]) {
                        stack.push(neighbor);
                    }
                }
            }
        }
    }
    
    // Find connected components
    public static int countConnectedComponents(Graph graph) {
        boolean[] visited = new boolean[graph.getVertices()];
        int components = 0;
        
        for (int i = 0; i < graph.getVertices(); i++) {
            if (!visited[i]) {
                dfsRecursive(graph, i, visited);
                components++;
                System.out.println(); // New line for each component
            }
        }
        
        return components;
    }
}
```

### Breadth-First Search (BFS)
```java
public class BFSAlgorithms {
    
    // Basic BFS traversal
    public static void bfs(Graph graph, int start) {
        boolean[] visited = new boolean[graph.getVertices()];
        Queue<Integer> queue = new LinkedList<>();
        
        visited[start] = true;
        queue.offer(start);
        
        while (!queue.isEmpty()) {
            int current = queue.poll();
            System.out.print(current + " ");
            
            for (int neighbor : graph.getNeighbors(current)) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    queue.offer(neighbor);
                }
            }
        }
    }
    
    // Shortest path using BFS
    public static int shortestPath(Graph graph, int start, int end) {
        boolean[] visited = new boolean[graph.getVertices()];
        int[] distance = new int[graph.getVertices()];
        Queue<Integer> queue = new LinkedList<>();
        
        visited[start] = true;
        queue.offer(start);
        
        while (!queue.isEmpty()) {
            int current = queue.poll();
            
            if (current == end) {
                return distance[current];
            }
            
            for (int neighbor : graph.getNeighbors(current)) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    distance[neighbor] = distance[current] + 1;
                    queue.offer(neighbor);
                }
            }
        }
        
        return -1; // No path found
    }
}
```

### Dijkstra's Shortest Path Algorithm
```java
import java.util.*;

class Edge {
    int destination;
    int weight;
    
    public Edge(int destination, int weight) {
        this.destination = destination;
        this.weight = weight;
    }
}

class WeightedGraph {
    private int vertices;
    private List<List<Edge>> adjacencyList;
    
    public WeightedGraph(int vertices) {
        this.vertices = vertices;
        this.adjacencyList = new ArrayList<>();
        for (int i = 0; i < vertices; i++) {
            adjacencyList.add(new ArrayList<>());
        }
    }
    
    public void addEdge(int source, int destination, int weight) {
        adjacencyList.get(source).add(new Edge(destination, weight));
        adjacencyList.get(destination).add(new Edge(source, weight)); // Undirected
    }
}

public class DijkstraAlgorithm {
    
    public static int[] dijkstra(WeightedGraph graph, int start) {
        int[] distances = new int[graph.getVertices()];
        boolean[] visited = new boolean[graph.getVertices()];
        PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[1] - b[1]);
        
        Arrays.fill(distances, Integer.MAX_VALUE);
        distances[start] = 0;
        pq.offer(new int[]{start, 0});
        
        while (!pq.isEmpty()) {
            int[] current = pq.poll();
            int vertex = current[0];
            int distance = current[1];
            
            if (visited[vertex]) continue;
            visited[vertex] = true;
            
            for (Edge edge : graph.getNeighbors(vertex)) {
                int neighbor = edge.destination;
                int weight = edge.weight;
                
                if (!visited[neighbor] && distances[vertex] + weight < distances[neighbor]) {
                    distances[neighbor] = distances[vertex] + weight;
                    pq.offer(new int[]{neighbor, distances[neighbor]});
                }
            }
        }
        
        return distances;
    }
}
```

### Minimum Spanning Tree (Kruskal's Algorithm)
```java
class UnionFind {
    private int[] parent;
    private int[] rank;
    
    public UnionFind(int n) {
        parent = new int[n];
        rank = new int[n];
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }
    
    public int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]); // Path compression
        }
        return parent[x];
    }
    
    public boolean union(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        
        if (rootX == rootY) return false;
        
        if (rank[rootX] < rank[rootY]) {
            parent[rootX] = rootY;
        } else if (rank[rootX] > rank[rootY]) {
            parent[rootY] = rootX;
        } else {
            parent[rootY] = rootX;
            rank[rootX]++;
        }
        
        return true;
    }
}

class Edge implements Comparable<Edge> {
    int source, destination, weight;
    
    public Edge(int source, int destination, int weight) {
        this.source = source;
        this.destination = destination;
        this.weight = weight;
    }
    
    @Override
    public int compareTo(Edge other) {
        return Integer.compare(this.weight, other.weight);
    }
}

public class KruskalMST {
    
    public static List<Edge> kruskalMST(List<Edge> edges, int vertices) {
        Collections.sort(edges);
        UnionFind uf = new UnionFind(vertices);
        List<Edge> mst = new ArrayList<>();
        
        for (Edge edge : edges) {
            if (uf.union(edge.source, edge.destination)) {
                mst.add(edge);
                if (mst.size() == vertices - 1) break;
            }
        }
        
        return mst;
    }
    
    public static int mstWeight(List<Edge> mst) {
        return mst.stream().mapToInt(edge -> edge.weight).sum();
    }
}
```

### Topological Sorting
```java
public class TopologicalSort {
    
    // Using DFS
    public static List<Integer> topologicalSortDFS(Graph graph) {
        boolean[] visited = new boolean[graph.getVertices()];
        Stack<Integer> stack = new Stack<>();
        
        for (int i = 0; i < graph.getVertices(); i++) {
            if (!visited[i]) {
                dfsTopological(graph, i, visited, stack);
            }
        }
        
        List<Integer> result = new ArrayList<>();
        while (!stack.isEmpty()) {
            result.add(stack.pop());
        }
        
        return result;
    }
    
    private static void dfsTopological(Graph graph, int vertex, boolean[] visited, Stack<Integer> stack) {
        visited[vertex] = true;
        
        for (int neighbor : graph.getNeighbors(vertex)) {
            if (!visited[neighbor]) {
                dfsTopological(graph, neighbor, visited, stack);
            }
        }
        
        stack.push(vertex);
    }
    
    // Using Kahn's Algorithm (BFS-based)
    public static List<Integer> topologicalSortKahn(Graph graph) {
        int[] inDegree = new int[graph.getVertices()];
        
        // Calculate in-degrees
        for (int i = 0; i < graph.getVertices(); i++) {
            for (int neighbor : graph.getNeighbors(i)) {
                inDegree[neighbor]++;
            }
        }
        
        Queue<Integer> queue = new LinkedList<>();
        for (int i = 0; i < graph.getVertices(); i++) {
            if (inDegree[i] == 0) {
                queue.offer(i);
            }
        }
        
        List<Integer> result = new ArrayList<>();
        while (!queue.isEmpty()) {
            int current = queue.poll();
            result.add(current);
            
            for (int neighbor : graph.getNeighbors(current)) {
                inDegree[neighbor]--;
                if (inDegree[neighbor] == 0) {
                    queue.offer(neighbor);
                }
            }
        }
        
        return result;
    }
}
```

## 🔍 Algorithm Analysis
- **DFS Time Complexity**: O(V + E) where V = vertices, E = edges
- **BFS Time Complexity**: O(V + E)
- **Dijkstra Time Complexity**: O((V + E) log V) with priority queue
- **Kruskal Time Complexity**: O(E log E) due to sorting
- **Topological Sort Time Complexity**: O(V + E)

## 💡 Learning Points
- Graph algorithms solve many real-world problems
- DFS is good for exploring all possibilities
- BFS finds shortest paths in unweighted graphs
- Dijkstra's algorithm handles weighted shortest paths
- MST algorithms find minimum cost connections
- Topological sort handles dependency ordering
