package com.example.GwDanganApp.controllers.tasks;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.GwDanganApp.Repositories.tasks.TaskRepository;
import com.example.GwDanganApp.models.tasks.Task;
import com.example.GwDanganApp.services.tasks.TaskService;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {
    
    @Autowired
    private TaskService taskService;
    
    @GetMapping
    public List<Task> getAllTasks() {
        return taskService.getAllTasks();
    }
    
    @PostMapping
    public Task createTask(@RequestBody Task task) {
        return taskService.createTask(task);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Task> getTaskById(@PathVariable Long id) {
        Task task = taskService.getTaskById(id);
        if (task != null) {
            return ResponseEntity.ok(task);
        }else{
            return ResponseEntity.notFound().build();
        }
    }
    
    // 他のエンドポイントも追加可能
}
