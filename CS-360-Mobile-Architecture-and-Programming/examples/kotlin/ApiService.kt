package com.example.mobileapp.network

import com.example.mobileapp.model.User
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
    
    @GET("users")
    suspend fun getUsers(): Response<List<User>>
    
    @GET("users/{id}")
    suspend fun getUser(@Path("id") userId: Int): Response<User>
    
    @POST("users")
    suspend fun createUser(@Body user: User): Response<User>
    
    @PUT("users/{id}")
    suspend fun updateUser(@Path("id") userId: Int, @Body user: User): Response<User>
    
    @DELETE("users/{id}")
    suspend fun deleteUser(@Path("id") userId: Int): Response<Unit>
    
    @GET("users/search")
    suspend fun searchUsers(@Query("q") query: String): Response<List<User>>
}
