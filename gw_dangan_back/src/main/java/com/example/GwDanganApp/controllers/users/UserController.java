package com.example.GwDanganApp.controllers.users;

import java.net.URI;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.example.GwDanganApp.models.users.User;
import com.example.GwDanganApp.services.users.UserService;

import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;




@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping
    public ResponseEntity<User> createUser(@Valid @RequestBody User user) {
        User createdUser = userService.createUser(user);
        URI location = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{firebaseUid}")
                .buildAndExpand(createdUser.getFirebaseUid())
                .toUri();
        return ResponseEntity.created(location).body(createdUser);
    }
    
    @GetMapping("/{firebaseUid}")
    public ResponseEntity<User> getUserData(@PathVariable String firebaseUid) {
       
        User userData = userService.getUserById(firebaseUid);
        if (userData == null) {
            return ResponseEntity.notFound().build();
        }
        
        return ResponseEntity.ok(userData);
    }

    
    
    @PutMapping("/{firebaseUid}")
    public ResponseEntity<User> updateUserName(@PathVariable String firebaseUid, @RequestBody String name) {
        User updatedUser = userService.updateName(firebaseUid, name);
        return ResponseEntity.ok(updatedUser);
    }

    @GetMapping
    public ResponseEntity<List<User>> getAllUserData() {
        List<User> users = userService.getAllUserData();
        if (users.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(users);
    }
}
