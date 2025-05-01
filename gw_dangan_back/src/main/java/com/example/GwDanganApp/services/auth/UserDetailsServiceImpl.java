package com.example.GwDanganApp.services.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.GwDanganApp.Repositories.auth.UserRepository;
import com.example.GwDanganApp.models.auth.User;


@Service
public class UserDetailsServiceImpl implements UserDetailsService{
    @Autowired
    UserRepository userRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String usename) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(usename)
                .orElseThrow(() -> new UsernameNotFoundException("User Not Found with username: " + usename));

        return UserDetailsImpl.build(user);               
    }

    
}
