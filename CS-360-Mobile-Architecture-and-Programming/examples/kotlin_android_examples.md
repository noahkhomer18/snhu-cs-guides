# CS-360 Kotlin Android Development Examples

## 🎯 Purpose
Demonstrate modern Android app development using Kotlin, including activities, fragments, database integration, and networking with coroutines.

## 📝 Kotlin Android Examples

### Basic Android Activity (Kotlin)
```kotlin
// MainActivity.kt
package com.example.mobileapp

import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.example.mobileapp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityMainBinding
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupClickListeners()
    }
    
    private fun setupClickListeners() {
        binding.buttonGreet.setOnClickListener {
            greetUser()
        }
    }
    
    private fun greetUser() {
        val name = binding.editTextName.text.toString().trim()
        
        if (name.isEmpty()) {
            Toast.makeText(this, "Please enter your name", Toast.LENGTH_SHORT).show()
            return
        }
        
        val greeting = "Hello, $name! Welcome to Android with Kotlin!"
        binding.textViewGreeting.text = greeting
    }
}
```

### Modern Fragment Implementation
```kotlin
// UserProfileFragment.kt
package com.example.mobileapp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.example.mobileapp.databinding.FragmentUserProfileBinding

class UserProfileFragment : Fragment() {
    
    private var _binding: FragmentUserProfileBinding? = null
    private val binding get() = _binding!!
    
    private var userName: String? = null
    private var userEmail: String? = null
    
    companion object {
        private const val ARG_USER_NAME = "user_name"
        private const val ARG_USER_EMAIL = "user_email"
        
        fun newInstance(name: String, email: String): UserProfileFragment {
            return UserProfileFragment().apply {
                arguments = Bundle().apply {
                    putString(ARG_USER_NAME, name)
                    putString(ARG_USER_EMAIL, email)
                }
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            userName = it.getString(ARG_USER_NAME)
            userEmail = it.getString(ARG_USER_EMAIL)
        }
    }
    
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentUserProfileBinding.inflate(inflater, container, false)
        return binding.root
    }
    
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupUserInfo()
    }
    
    private fun setupUserInfo() {
        binding.textViewUserName.text = "Name: $userName"
        binding.textViewUserEmail.text = "Email: $userEmail"
    }
    
    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
```

### Data Class Model
```kotlin
// User.kt
package com.example.mobileapp

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

@Parcelize
data class User(
    val id: Int = 0,
    val name: String,
    val email: String,
    val phone: String? = null
) : Parcelable {
    
    companion object {
        fun create(name: String, email: String, phone: String? = null): User {
            return User(
                name = name,
                email = email,
                phone = phone
            )
        }
    }
    
    val displayName: String
        get() = name.ifEmpty { "Unknown User" }
    
    val isValidEmail: Boolean
        get() = email.contains("@") && email.contains(".")
}
```

### Room Database with Kotlin
```kotlin
// UserDao.kt
package com.example.mobileapp.database

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Dao
interface UserDao {
    
    @Query("SELECT * FROM users ORDER BY name ASC")
    fun getAllUsers(): Flow<List<User>>
    
    @Query("SELECT * FROM users WHERE id = :userId")
    suspend fun getUserById(userId: Int): User?
    
    @Query("SELECT * FROM users WHERE email = :email")
    suspend fun getUserByEmail(email: String): User?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertUser(user: User): Long
    
    @Update
    suspend fun updateUser(user: User)
    
    @Delete
    suspend fun deleteUser(user: User)
    
    @Query("DELETE FROM users WHERE id = :userId")
    suspend fun deleteUserById(userId: Int)
}
```

### Database Entity
```kotlin
// UserEntity.kt
package com.example.mobileapp.database

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "users")
data class UserEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val name: String,
    val email: String,
    val phone: String? = null,
    val createdAt: Long = System.currentTimeMillis()
) {
    fun toUser(): User {
        return User(
            id = id,
            name = name,
            email = email,
            phone = phone
        )
    }
    
    companion object {
        fun fromUser(user: User): UserEntity {
            return UserEntity(
                id = user.id,
                name = user.name,
                email = user.email,
                phone = user.phone
            )
        }
    }
}
```

### Repository Pattern
```kotlin
// UserRepository.kt
package com.example.mobileapp.repository

import com.example.mobileapp.database.UserDao
import com.example.mobileapp.database.UserEntity
import com.example.mobileapp.model.User
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class UserRepository @Inject constructor(
    private val userDao: UserDao
) {
    
    fun getAllUsers(): Flow<List<User>> {
        return userDao.getAllUsers().map { entities ->
            entities.map { it.toUser() }
        }
    }
    
    suspend fun getUserById(userId: Int): User? {
        return userDao.getUserById(userId)
    }
    
    suspend fun getUserByEmail(email: String): User? {
        return userDao.getUserByEmail(email)
    }
    
    suspend fun insertUser(user: User): Long {
        return userDao.insertUser(UserEntity.fromUser(user))
    }
    
    suspend fun updateUser(user: User) {
        userDao.updateUser(UserEntity.fromUser(user))
    }
    
    suspend fun deleteUser(user: User) {
        userDao.deleteUser(UserEntity.fromUser(user))
    }
    
    suspend fun deleteUserById(userId: Int) {
        userDao.deleteUserById(userId)
    }
}
```

### RecyclerView Adapter with Kotlin
```kotlin
// UserAdapter.kt
package com.example.mobileapp.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.example.mobileapp.databinding.ItemUserBinding
import com.example.mobileapp.model.User

class UserAdapter(
    private val onUserClick: (User) -> Unit,
    private val onUserLongClick: (User) -> Unit
) : ListAdapter<User, UserAdapter.UserViewHolder>(UserDiffCallback()) {
    
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): UserViewHolder {
        val binding = ItemUserBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return UserViewHolder(binding)
    }
    
    override fun onBindViewHolder(holder: UserViewHolder, position: Int) {
        holder.bind(getItem(position))
    }
    
    inner class UserViewHolder(
        private val binding: ItemUserBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        
        fun bind(user: User) {
            binding.apply {
                textViewUserName.text = user.displayName
                textViewUserEmail.text = user.email
                textViewUserPhone.text = user.phone ?: "No phone"
                
                root.setOnClickListener {
                    onUserClick(user)
                }
                
                root.setOnLongClickListener {
                    onUserLongClick(user)
                    true
                }
            }
        }
    }
    
    class UserDiffCallback : DiffUtil.ItemCallback<User>() {
        override fun areItemsTheSame(oldItem: User, newItem: User): Boolean {
            return oldItem.id == newItem.id
        }
        
        override fun areContentsTheSame(oldItem: User, newItem: User): Boolean {
            return oldItem == newItem
        }
    }
}
```

### Network API with Retrofit and Kotlin
```kotlin
// ApiService.kt
package com.example.mobileapp.network

import com.example.mobileapp.model.User
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
    
    @GET("users")
    suspend fun getUsers(): Response<List<User>>
    
    @GET("users/{id}")
    suspend fun getUser(@Path("id") Int): Response<User>
    
    @POST("users")
    suspend fun createUser(@Body user: User): Response<User>
    
    @PUT("users/{id}")
    suspend fun updateUser(@Path("id") Int, @Body user: User): Response<User>
    
    @DELETE("users/{id}")
    suspend fun deleteUser(@Path("id") Int): Response<Unit>
}
```

### Network Manager with Coroutines
```kotlin
// NetworkManager.kt
package com.example.mobileapp.network

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import retrofit2.Response
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class NetworkManager @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun getUsers(): Result<List<User>> = withContext(Dispatchers.IO) {
        try {
            val response = apiService.getUsers()
            if (response.isSuccessful) {
                Result.success(response.body() ?: emptyList())
            } else {
                Result.failure(Exception("Failed to fetch users: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun getUser(userId: Int): Result<User> = withContext(Dispatchers.IO) {
        try {
            val response = apiService.getUser(userId)
            if (response.isSuccessful) {
                response.body()?.let { user ->
                    Result.success(user)
                } ?: Result.failure(Exception("User not found"))
            } else {
                Result.failure(Exception("Failed to fetch user: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun createUser(user: User): Result<User> = withContext(Dispatchers.IO) {
        try {
            val response = apiService.createUser(user)
            if (response.isSuccessful) {
                response.body()?.let { createdUser ->
                    Result.success(createdUser)
                } ?: Result.failure(Exception("Failed to create user"))
            } else {
                Result.failure(Exception("Failed to create user: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
```

### ViewModel with StateFlow
```kotlin
// UserViewModel.kt
package com.example.mobileapp.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.mobileapp.model.User
import com.example.mobileapp.repository.UserRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class UserViewModel @Inject constructor(
    private val userRepository: UserRepository
) : ViewModel() {
    
    private val _uiState = MutableStateFlow(UserUiState())
    val uiState: StateFlow<UserUiState> = _uiState.asStateFlow()
    
    init {
        loadUsers()
    }
    
    private fun loadUsers() {
        viewModelScope.launch {
            userRepository.getAllUsers().collect { users ->
                _uiState.value = _uiState.value.copy(
                    users = users,
                    isLoading = false
                )
            }
        }
    }
    
    fun addUser(name: String, email: String, phone: String?) {
        viewModelScope.launch {
            try {
                _uiState.value = _uiState.value.copy(isLoading = true)
                val user = User.create(name, email, phone)
                userRepository.insertUser(user)
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = null
                )
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = e.message
                )
            }
        }
    }
    
    fun deleteUser(user: User) {
        viewModelScope.launch {
            try {
                userRepository.deleteUser(user)
            } catch (e: Exception) {
                _uiState.value = _uiState.value.copy(error = e.message)
            }
        }
    }
    
    fun clearError() {
        _uiState.value = _uiState.value.copy(error = null)
    }
}

data class UserUiState(
    val users: List<User> = emptyList(),
    val isLoading: Boolean = true,
    val error: String? = null
)
```

## 🔍 Kotlin Android Concepts
- **Data Classes**: Concise way to create model classes
- **Null Safety**: Built-in null safety prevents NullPointerExceptions
- **Extension Functions**: Add functionality to existing classes
- **Coroutines**: Asynchronous programming with suspend functions
- **StateFlow**: Reactive state management
- **View Binding**: Type-safe view references
- **Room Database**: Modern database abstraction
- **Repository Pattern**: Clean architecture separation
- **Dependency Injection**: Using Hilt for dependency management

## 💡 Learning Points
- **Kotlin** is now the preferred language for Android development
- **Data classes** reduce boilerplate code significantly
- **Null safety** prevents common runtime crashes
- **Coroutines** provide efficient async programming
- **StateFlow** enables reactive UI updates
- **View Binding** is safer than findViewById
- **Room** provides compile-time SQL verification
- **Repository pattern** separates data access logic
- **Modern Android architecture** follows MVVM pattern
