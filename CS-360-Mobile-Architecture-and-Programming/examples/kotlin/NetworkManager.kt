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
    
    suspend fun updateUser(userId: Int, user: User): Result<User> = withContext(Dispatchers.IO) {
        try {
            val response = apiService.updateUser(userId, user)
            if (response.isSuccessful) {
                response.body()?.let { updatedUser ->
                    Result.success(updatedUser)
                } ?: Result.failure(Exception("Failed to update user"))
            } else {
                Result.failure(Exception("Failed to update user: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun deleteUser(userId: Int): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            val response = apiService.deleteUser(userId)
            if (response.isSuccessful) {
                Result.success(Unit)
            } else {
                Result.failure(Exception("Failed to delete user: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun searchUsers(query: String): Result<List<User>> = withContext(Dispatchers.IO) {
        try {
            val response = apiService.searchUsers(query)
            if (response.isSuccessful) {
                Result.success(response.body() ?: emptyList())
            } else {
                Result.failure(Exception("Failed to search users: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
