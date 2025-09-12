# CS-260 Graph Algorithms

## 🎯 Purpose
Demonstrate graph representation and traversal algorithms.

## 📝 Code Examples

### Graph Representation
```java
import java.util.*;

public class Graph {
    private int vertices;
    private LinkedList<Integer>[] adjacencyList;
    
    @SuppressWarnings("unchecked")
    public Graph(int vertices) {
        this.vertices = vertices;
        adjacencyList = new LinkedList[vertices];
        for (int i = 0; i < vertices; i++) {
            adjacencyList[i] = new LinkedList<>();
        }
    }
    
    // Add edge to graph
    public void addEdge(int source, int destination) {
        adjacencyList[source].add(destination);
        // For undirected graph, add both directions
        // adjacencyList[destination].add(source);
    }
    
    // Print graph
    public void printGraph() {
        for (int i = 0; i < vertices; i++) {
            System.out.print("Vertex " + i + " is connected to: ");
            for (Integer neighbor : adjacencyList[i]) {
                System.out.print(neighbor + " ");
            }
            System.out.println();
        }
    }
}
```

### Depth-First Search (DFS)
```java
public class DFS {
    private boolean[] visited;
    
    public void dfsTraversal(Graph graph, int startVertex) {
        visited = new boolean[graph.getVertices()];
        dfsRecursive(graph, startVertex);
    }
    
    private void dfsRecursive(Graph graph, int vertex) {
        visited[vertex] = true;
        System.out.print(vertex + " ");
        
        for (int neighbor : graph.getAdjacencyList()[vertex]) {
            if (!visited[neighbor]) {
                dfsRecursive(graph, neighbor);
            }
        }
    }
    
    // DFS using stack (iterative)
    public void dfsIterative(Graph graph, int startVertex) {
        boolean[] visited = new boolean[graph.getVertices()];
        Stack<Integer> stack = new Stack<>();
        
        stack.push(startVertex);
        
        while (!stack.isEmpty()) {
            int vertex = stack.pop();
            
            if (!visited[vertex]) {
                visited[vertex] = true;
                System.out.print(vertex + " ");
                
                for (int neighbor : graph.getAdjacencyList()[vertex]) {
                    if (!visited[neighbor]) {
                        stack.push(neighbor);
                    }
                }
            }
        }
    }
}
```

### Breadth-First Search (BFS)
```java
public class BFS {
    public void bfsTraversal(Graph graph, int startVertex) {
        boolean[] visited = new boolean[graph.getVertices()];
        Queue<Integer> queue = new LinkedList<>();
        
        visited[startVertex] = true;
        queue.add(startVertex);
        
        while (!queue.isEmpty()) {
            int vertex = queue.poll();
            System.out.print(vertex + " ");
            
            for (int neighbor : graph.getAdjacencyList()[vertex]) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    queue.add(neighbor);
                }
            }
        }
    }
    
    // BFS to find shortest path
    public int shortestPath(Graph graph, int start, int end) {
        boolean[] visited = new boolean[graph.getVertices()];
        int[] distance = new int[graph.getVertices()];
        Queue<Integer> queue = new LinkedList<>();
        
        visited[start] = true;
        queue.add(start);
        
        while (!queue.isEmpty()) {
            int vertex = queue.poll();
            
            if (vertex == end) {
                return distance[vertex];
            }
            
            for (int neighbor : graph.getAdjacencyList()[vertex]) {
                if (!visited[neighbor]) {
                    visited[neighbor] = true;
                    distance[neighbor] = distance[vertex] + 1;
                    queue.add(neighbor);
                }
            }
        }
        
        return -1; // No path found
    }
}
```

### Dijkstra's Algorithm
```java
public class Dijkstra {
    private static final int INF = Integer.MAX_VALUE;
    
    public int[] dijkstra(int[][] graph, int source) {
        int vertices = graph.length;
        int[] distance = new int[vertices];
        boolean[] visited = new boolean[vertices];
        
        // Initialize distances
        for (int i = 0; i < vertices; i++) {
            distance[i] = INF;
        }
        distance[source] = 0;
        
        for (int count = 0; count < vertices - 1; count++) {
            int u = minDistance(distance, visited);
            visited[u] = true;
            
            for (int v = 0; v < vertices; v++) {
                if (!visited[v] && graph[u][v] != 0 && 
                    distance[u] != INF && 
                    distance[u] + graph[u][v] < distance[v]) {
                    distance[v] = distance[u] + graph[u][v];
                }
            }
        }
        
        return distance;
    }
    
    private int minDistance(int[] distance, boolean[] visited) {
        int min = INF;
        int minIndex = -1;
        
        for (int v = 0; v < distance.length; v++) {
            if (!visited[v] && distance[v] <= min) {
                min = distance[v];
                minIndex = v;
            }
        }
        
        return minIndex;
    }
}
```

## 🔍 Algorithm Analysis

| Algorithm | Time Complexity | Space Complexity | Use Case |
|-----------|----------------|------------------|----------|
| DFS | O(V + E) | O(V) | Path finding, cycle detection |
| BFS | O(V + E) | O(V) | Shortest path (unweighted) |
| Dijkstra | O(V²) | O(V) | Shortest path (weighted) |

## 💡 Learning Points
- **Graph Representation**: Adjacency list vs adjacency matrix
- **Traversal**: DFS uses recursion/stack, BFS uses queue
- **Applications**: Social networks, maps, web crawling
- **Weighted Graphs**: Use Dijkstra's for shortest paths
- **Cycle Detection**: DFS can detect cycles in directed graphs
