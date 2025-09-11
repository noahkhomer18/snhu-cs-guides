# Binary Search Tree Lab – Example

## Tasks
- Insert node
- Delete node
- Inorder, Preorder, Postorder traversal

## C++ Example
```cpp
struct Node {
    int key;
    Node* left;
    Node* right;
    Node(int k) : key(k), left(nullptr), right(nullptr) {}
};

class BST {
    Node* root;
    Node* insert(Node* node, int key) {
        if (!node) return new Node(key);
        if (key < node->key) node->left = insert(node->left, key);
        else node->right = insert(node->right, key);
        return node;
    }
};
```
