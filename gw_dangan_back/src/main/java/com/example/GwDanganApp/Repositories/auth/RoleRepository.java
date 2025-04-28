package com.example.GwDanganApp.Repositories.auth;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.GwDanganApp.models.auth.Erole;
import com.example.GwDanganApp.models.auth.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(Erole name);
}
