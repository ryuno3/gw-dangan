package com.example.GwDanganApp.models.users;

import java.util.ArrayList;
import java.util.List;

import com.example.GwDanganApp.models.tasks.Task;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.NoArgsConstructor;


@Entity
@Table(name= "user_data")
@NoArgsConstructor
public class User {
    @Id
    private String firebaseUid;

    @NotBlank(message = "Name is required")
    private String name;

    private String email;

    @OneToMany(mappedBy = "author")
    private List<Task> tasks;

    public User(String firebaseUid, String name, String email) {
        this.firebaseUid = firebaseUid;
        this.name = name;
        this.email = email;
        this.tasks = new ArrayList<>();
    }

    public List<Task> getTasks() {
        return tasks;
    }
    public void setTask(Task task) {
        this.tasks.add(task);
    }

    public String getFirebaseUid(){
        return firebaseUid;
    }

    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }

    public String getEmail(){
        return email;
    }
}