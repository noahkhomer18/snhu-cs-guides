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
    
    val formattedPhone: String
        get() = phone?.let { 
            if (it.length == 10) {
                "(${it.substring(0, 3)}) ${it.substring(3, 6)}-${it.substring(6)}"
            } else {
                it
            }
        } ?: "No phone number"
}
