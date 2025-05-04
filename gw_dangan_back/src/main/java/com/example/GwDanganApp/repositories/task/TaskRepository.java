package com.example.GwDanganApp.repositories.task;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.GwDanganApp.models.tasks.Task;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {

    List<Task> findByAuthor_FirebaseUid(String firebaseUid);
    
}


