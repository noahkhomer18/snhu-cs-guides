# CS-465 React Frontend Development

## 🎯 Purpose
Demonstrate React frontend development with components, state management, and API integration.

## 📝 React Frontend Examples

### Basic React Component
```jsx
// App.js
import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/users');
      if (!response.ok) throw new Error('Failed to fetch users');
      const data = await response.json();
      setUsers(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Loading...</div>;
  if (error) return <div className="error">Error: {error}</div>;

  return (
    <div className="App">
      <header className="App-header">
        <h1>User Management System</h1>
        <UserList users={users} onUserUpdate={fetchUsers} />
      </header>
    </div>
  );
}

export default App;
```

### User List Component
```jsx
// UserList.js
import React, { useState } from 'react';
import UserCard from './UserCard';
import UserForm from './UserForm';

function UserList({ users, onUserUpdate }) {
  const [showForm, setShowForm] = useState(false);
  const [editingUser, setEditingUser] = useState(null);

  const handleEdit = (user) => {
    setEditingUser(user);
    setShowForm(true);
  };

  const handleAdd = () => {
    setEditingUser(null);
    setShowForm(true);
  };

  const handleFormClose = () => {
    setShowForm(false);
    setEditingUser(null);
  };

  const handleUserSave = () => {
    onUserUpdate();
    handleFormClose();
  };

  return (
    <div className="user-list">
      <div className="user-list-header">
        <h2>Users ({users.length})</h2>
        <button onClick={handleAdd} className="btn btn-primary">
          Add User
        </button>
      </div>
      
      <div className="user-grid">
        {users.map(user => (
          <UserCard
            key={user.id}
            user={user}
            onEdit={handleEdit}
            onDelete={onUserUpdate}
          />
        ))}
      </div>

      {showForm && (
        <UserForm
          user={editingUser}
          onSave={handleUserSave}
          onCancel={handleFormClose}
        />
      )}
    </div>
  );
}

export default UserList;
```

### User Card Component
```jsx
// UserCard.js
import React from 'react';

function UserCard({ user, onEdit, onDelete }) {
  const handleDelete = async () => {
    if (window.confirm('Are you sure you want to delete this user?')) {
      try {
        const response = await fetch(`/api/users/${user.id}`, {
          method: 'DELETE'
        });
        if (response.ok) {
          onDelete();
        }
      } catch (error) {
        console.error('Error deleting user:', error);
      }
    }
  };

  return (
    <div className="user-card">
      <div className="user-avatar">
        <img src={user.avatar || '/default-avatar.png'} alt={user.name} />
      </div>
      <div className="user-info">
        <h3>{user.name}</h3>
        <p className="user-email">{user.email}</p>
        <p className="user-role">{user.role}</p>
        <div className="user-actions">
          <button onClick={() => onEdit(user)} className="btn btn-sm btn-secondary">
            Edit
          </button>
          <button onClick={handleDelete} className="btn btn-sm btn-danger">
            Delete
          </button>
        </div>
      </div>
    </div>
  );
}

export default UserCard;
```

### User Form Component
```jsx
// UserForm.js
import React, { useState, useEffect } from 'react';

function UserForm({ user, onSave, onCancel }) {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    role: 'user',
    phone: ''
  });

  useEffect(() => {
    if (user) {
      setFormData({
        name: user.name || '',
        email: user.email || '',
        role: user.role || 'user',
        phone: user.phone || ''
      });
    }
  }, [user]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    try {
      const url = user ? `/api/users/${user.id}` : '/api/users';
      const method = user ? 'PUT' : 'POST';
      
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData)
      });

      if (response.ok) {
        onSave();
      } else {
        throw new Error('Failed to save user');
      }
    } catch (error) {
      console.error('Error saving user:', error);
    }
  };

  return (
    <div className="modal-overlay">
      <div className="modal">
        <div className="modal-header">
          <h2>{user ? 'Edit User' : 'Add User'}</h2>
          <button onClick={onCancel} className="btn-close">&times;</button>
        </div>
        
        <form onSubmit={handleSubmit} className="user-form">
          <div className="form-group">
            <label htmlFor="name">Name:</label>
            <input
              type="text"
              id="name"
              name="name"
              value={formData.name}
              onChange={handleChange}
              required
            />
          </div>
          
          <div className="form-group">
            <label htmlFor="email">Email:</label>
            <input
              type="email"
              id="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              required
            />
          </div>
          
          <div className="form-group">
            <label htmlFor="role">Role:</label>
            <select
              id="role"
              name="role"
              value={formData.role}
              onChange={handleChange}
            >
              <option value="user">User</option>
              <option value="admin">Admin</option>
              <option value="moderator">Moderator</option>
            </select>
          </div>
          
          <div className="form-group">
            <label htmlFor="phone">Phone:</label>
            <input
              type="tel"
              id="phone"
              name="phone"
              value={formData.phone}
              onChange={handleChange}
            />
          </div>
          
          <div className="form-actions">
            <button type="button" onClick={onCancel} className="btn btn-secondary">
              Cancel
            </button>
            <button type="submit" className="btn btn-primary">
              {user ? 'Update' : 'Create'} User
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default UserForm;
```

### CSS Styles
```css
/* App.css */
.App {
  text-align: center;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.App-header {
  background-color: #282c34;
  padding: 20px;
  color: white;
  border-radius: 8px;
  margin-bottom: 20px;
}

.loading, .error {
  padding: 20px;
  font-size: 18px;
}

.error {
  color: #ff6b6b;
}

.user-list {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.user-list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.user-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.user-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 20px;
  background: #f9f9f9;
  transition: transform 0.2s;
}

.user-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.user-avatar img {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  object-fit: cover;
}

.user-info h3 {
  margin: 10px 0 5px 0;
  color: #333;
}

.user-email {
  color: #666;
  margin: 5px 0;
}

.user-role {
  color: #888;
  font-size: 14px;
  margin: 5px 0 15px 0;
}

.user-actions {
  display: flex;
  gap: 10px;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.2s;
}

.btn-primary {
  background-color: #007bff;
  color: white;
}

.btn-primary:hover {
  background-color: #0056b3;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
}

.btn-secondary:hover {
  background-color: #545b62;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
}

.btn-danger:hover {
  background-color: #c82333;
}

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal {
  background: white;
  border-radius: 8px;
  padding: 0;
  max-width: 500px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #ddd;
}

.btn-close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #666;
}

.user-form {
  padding: 20px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}
```

## 🔍 React Concepts
- **Components**: Reusable UI building blocks
- **State Management**: Managing component data
- **Props**: Passing data between components
- **Hooks**: useState, useEffect for state and side effects
- **Event Handling**: User interaction management
- **API Integration**: Fetching data from backend
- **Conditional Rendering**: Showing/hiding elements based on state
- **Forms**: Handling user input and validation

## 💡 Learning Points
- **Components** make code reusable and maintainable
- **State** drives UI updates and user interactions
- **Props** enable data flow between components
- **Hooks** provide powerful state and lifecycle management
- **Event handling** creates interactive user experiences
- **API integration** connects frontend to backend services
- **Conditional rendering** creates dynamic UIs
- **Form handling** manages user input effectively
