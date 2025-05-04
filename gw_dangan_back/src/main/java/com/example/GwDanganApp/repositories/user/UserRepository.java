package com.example.GwDanganApp.repositories.user;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.GwDanganApp.models.users.User;

public interface UserRepository extends JpaRepository<User, String> {    
}
