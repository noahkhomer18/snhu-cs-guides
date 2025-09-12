# CS-465 Frontend Development with React

## 🎯 Purpose
Demonstrate modern frontend development with React, including components, state management, and API integration.

## 📝 React Examples

### Component Structure
```jsx
// UserList.jsx
import React, { useState, useEffect } from 'react';
import UserCard from './UserCard';
import UserForm from './UserForm';
import { userService } from '../services/userService';

const UserList = () => {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [showForm, setShowForm] = useState(false);

    useEffect(() => {
        fetchUsers();
    }, []);

    const fetchUsers = async () => {
        try {
            setLoading(true);
            const userData = await userService.getAllUsers();
            setUsers(userData);
        } catch (err) {
            setError('Failed to fetch users');
        } finally {
            setLoading(false);
        }
    };

    const handleAddUser = async (userData) => {
        try {
            const newUser = await userService.createUser(userData);
            setUsers([...users, newUser]);
            setShowForm(false);
        } catch (err) {
            setError('Failed to create user');
        }
    };

    const handleDeleteUser = async (userId) => {
        try {
            await userService.deleteUser(userId);
            setUsers(users.filter(user => user.id !== userId));
        } catch (err) {
            setError('Failed to delete user');
        }
    };

    if (loading) return <div className="loading">Loading users...</div>;
    if (error) return <div className="error">{error}</div>;

    return (
        <div className="user-list">
            <div className="header">
                <h1>User Management</h1>
                <button 
                    className="btn btn-primary"
                    onClick={() => setShowForm(true)}
                >
                    Add User
                </button>
            </div>

            {showForm && (
                <UserForm 
                    onSubmit={handleAddUser}
                    onCancel={() => setShowForm(false)}
                />
            )}

            <div className="users-grid">
                {users.map(user => (
                    <UserCard 
                        key={user.id}
                        user={user}
                        onDelete={handleDeleteUser}
                    />
                ))}
            </div>
        </div>
    );
};

export default UserList;
```

### State Management with Context
```jsx
// AuthContext.jsx
import React, { createContext, useContext, useReducer, useEffect } from 'react';
import { authService } from '../services/authService';

const AuthContext = createContext();

const authReducer = (state, action) => {
    switch (action.type) {
        case 'LOGIN_START':
            return { ...state, loading: true, error: null };
        case 'LOGIN_SUCCESS':
            return {
                ...state,
                loading: false,
                isAuthenticated: true,
                user: action.payload.user,
                token: action.payload.token
            };
        case 'LOGIN_FAILURE':
            return {
                ...state,
                loading: false,
                isAuthenticated: false,
                error: action.payload
            };
        case 'LOGOUT':
            return {
                ...state,
                isAuthenticated: false,
                user: null,
                token: null
            };
        case 'CLEAR_ERROR':
            return { ...state, error: null };
        default:
            return state;
    }
};

export const AuthProvider = ({ children }) => {
    const [state, dispatch] = useReducer(authReducer, {
        isAuthenticated: false,
        user: null,
        token: null,
        loading: false,
        error: null
    });

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            // Verify token and set user
            authService.verifyToken(token)
                .then(user => {
                    dispatch({
                        type: 'LOGIN_SUCCESS',
                        payload: { user, token }
                    });
                })
                .catch(() => {
                    localStorage.removeItem('token');
                });
        }
    }, []);

    const login = async (credentials) => {
        dispatch({ type: 'LOGIN_START' });
        try {
            const response = await authService.login(credentials);
            localStorage.setItem('token', response.token);
            dispatch({
                type: 'LOGIN_SUCCESS',
                payload: response
            });
        } catch (error) {
            dispatch({
                type: 'LOGIN_FAILURE',
                payload: error.message
            });
        }
    };

    const logout = () => {
        localStorage.removeItem('token');
        dispatch({ type: 'LOGOUT' });
    };

    const clearError = () => {
        dispatch({ type: 'CLEAR_ERROR' });
    };

    return (
        <AuthContext.Provider value={{
            ...state,
            login,
            logout,
            clearError
        }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within an AuthProvider');
    }
    return context;
};
```

### API Service Layer
```jsx
// userService.js
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080/api';

const apiClient = axios.create({
    baseURL: API_BASE_URL,
    headers: {
        'Content-Type': 'application/json'
    }
});

// Request interceptor to add auth token
apiClient.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// Response interceptor to handle errors
apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response?.status === 401) {
            localStorage.removeItem('token');
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
);

export const userService = {
    async getAllUsers(page = 0, size = 10) {
        const response = await apiClient.get(`/users?page=${page}&size=${size}`);
        return response.data;
    },

    async getUserById(id) {
        const response = await apiClient.get(`/users/${id}`);
        return response.data;
    },

    async createUser(userData) {
        const response = await apiClient.post('/users', userData);
        return response.data;
    },

    async updateUser(id, userData) {
        const response = await apiClient.put(`/users/${id}`, userData);
        return response.data;
    },

    async deleteUser(id) {
        await apiClient.delete(`/users/${id}`);
    }
};

export const authService = {
    async login(credentials) {
        const response = await apiClient.post('/auth/login', credentials);
        return response.data;
    },

    async register(userData) {
        const response = await apiClient.post('/auth/register', userData);
        return response.data;
    },

    async verifyToken(token) {
        const response = await apiClient.get('/auth/verify', {
            headers: { Authorization: `Bearer ${token}` }
        });
        return response.data;
    }
};
```

### Form Handling with Validation
```jsx
// UserForm.jsx
import React, { useState } from 'react';
import { useForm } from 'react-hook-form';

const UserForm = ({ onSubmit, onCancel, initialData = {} }) => {
    const { register, handleSubmit, formState: { errors }, reset } = useForm({
        defaultValues: initialData
    });
    const [isSubmitting, setIsSubmitting] = useState(false);

    const handleFormSubmit = async (data) => {
        setIsSubmitting(true);
        try {
            await onSubmit(data);
            reset();
        } catch (error) {
            console.error('Form submission error:', error);
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <form onSubmit={handleSubmit(handleFormSubmit)} className="user-form">
            <div className="form-group">
                <label htmlFor="name">Name</label>
                <input
                    type="text"
                    id="name"
                    {...register('name', {
                        required: 'Name is required',
                        minLength: {
                            value: 2,
                            message: 'Name must be at least 2 characters'
                        }
                    })}
                    className={errors.name ? 'error' : ''}
                />
                {errors.name && (
                    <span className="error-message">{errors.name.message}</span>
                )}
            </div>

            <div className="form-group">
                <label htmlFor="email">Email</label>
                <input
                    type="email"
                    id="email"
                    {...register('email', {
                        required: 'Email is required',
                        pattern: {
                            value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                            message: 'Invalid email address'
                        }
                    })}
                    className={errors.email ? 'error' : ''}
                />
                {errors.email && (
                    <span className="error-message">{errors.email.message}</span>
                )}
            </div>

            <div className="form-group">
                <label htmlFor="password">Password</label>
                <input
                    type="password"
                    id="password"
                    {...register('password', {
                        required: 'Password is required',
                        minLength: {
                            value: 8,
                            message: 'Password must be at least 8 characters'
                        }
                    })}
                    className={errors.password ? 'error' : ''}
                />
                {errors.password && (
                    <span className="error-message">{errors.password.message}</span>
                )}
            </div>

            <div className="form-actions">
                <button
                    type="button"
                    onClick={onCancel}
                    className="btn btn-secondary"
                    disabled={isSubmitting}
                >
                    Cancel
                </button>
                <button
                    type="submit"
                    className="btn btn-primary"
                    disabled={isSubmitting}
                >
                    {isSubmitting ? 'Saving...' : 'Save User'}
                </button>
            </div>
        </form>
    );
};

export default UserForm;
```

### Routing and Navigation
```jsx
// App.jsx
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import ProtectedRoute from './components/ProtectedRoute';
import Navbar from './components/Navbar';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import UserList from './pages/UserList';
import UserProfile from './pages/UserProfile';
import './App.css';

function App() {
    return (
        <AuthProvider>
            <Router>
                <div className="App">
                    <Navbar />
                    <main className="main-content">
                        <Routes>
                            <Route path="/login" element={<Login />} />
                            <Route
                                path="/dashboard"
                                element={
                                    <ProtectedRoute>
                                        <Dashboard />
                                    </ProtectedRoute>
                                }
                            />
                            <Route
                                path="/users"
                                element={
                                    <ProtectedRoute>
                                        <UserList />
                                    </ProtectedRoute>
                                }
                            />
                            <Route
                                path="/profile"
                                element={
                                    <ProtectedRoute>
                                        <UserProfile />
                                    </ProtectedRoute>
                                }
                            />
                            <Route path="/" element={<Navigate to="/dashboard" />} />
                        </Routes>
                    </main>
                </div>
            </Router>
        </AuthProvider>
    );
}

export default App;
```

## 🔍 React Best Practices

### Component Design Principles
- **Single Responsibility**: Each component has one clear purpose
- **Composition over Inheritance**: Build complex UIs from simple components
- **Props Validation**: Use PropTypes or TypeScript for type safety
- **Controlled Components**: Manage form state with React state

### Performance Optimization
- **React.memo**: Prevent unnecessary re-renders
- **useMemo/useCallback**: Optimize expensive calculations
- **Code Splitting**: Load components on demand
- **Lazy Loading**: Defer loading of non-critical components

## 💡 Learning Points
- React uses a virtual DOM for efficient updates
- Hooks provide stateful logic in functional components
- Context API enables global state management
- Custom hooks promote code reuse
- Proper error handling improves user experience
