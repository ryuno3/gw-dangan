package com.example.GwDanganApp.services.users;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.GwDanganApp.models.users.User;
import com.example.GwDanganApp.repositories.user.UserRepository;
import com.example.GwDanganApp.utils.error.users.UserNotFoundException;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public User getUserById(String firebaseUid) {
        User user = userRepository.findById(firebaseUid).get();
        if (user == null) {
            throw new UserNotFoundException("User not found with id: " + firebaseUid);
        }
        return user;
    }

    public User createUser(User user) {
        User existingUser = userRepository.findById(user.getFirebaseUid()).orElse(null);
        
        // Firebase UIDが重複していないか確認
        if (existingUser != null) {
            throw new UserNotFoundException("User already exists with id: " + user.getFirebaseUid());
        }
        return userRepository.save(user);
    }

    public User updateName(String firebaseUid, String name) {
        User user = getUserById(firebaseUid);
        user.setName(name);
        return userRepository.save(user);
    }
    
}
