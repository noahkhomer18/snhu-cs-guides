# Hash Table with Chaining – Example

## Concept
- Array of linked lists
- Collisions handled by chaining

## C++ Skeleton
```cpp
#include <list>
#include <vector>
using namespace std;

class HashTable {
    vector<list<int>> table;
    int size;
public:
    HashTable(int s) : size(s) { table.resize(s); }
    int hash(int key) { return key % size; }
    void insert(int key) { table[hash(key)].push_back(key); }
};
```
