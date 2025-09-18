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
        
        binding.buttonClear.setOnClickListener {
            clearFields()
        }
    }
    
    private fun greetUser() {
        val name = binding.editTextName.text.toString().trim()
        
        if (name.isEmpty()) {
            showToast("Please enter your name")
            return
        }
        
        val greeting = "Hello, $name! Welcome to Android with Kotlin!"
        binding.textViewGreeting.text = greeting
    }
    
    private fun clearFields() {
        binding.editTextName.text?.clear()
        binding.textViewGreeting.text = ""
    }
    
    private fun showToast(message: String) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    }
}
