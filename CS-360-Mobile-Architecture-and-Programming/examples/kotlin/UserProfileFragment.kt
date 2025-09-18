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
        binding.apply {
            textViewUserName.text = "Name: ${userName ?: "Unknown"}"
            textViewUserEmail.text = "Email: ${userEmail ?: "No email"}"
        }
    }
    
    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
