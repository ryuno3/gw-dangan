package com.example.GwDanganApp.controllers.tasks;

import java.net.URI;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.example.GwDanganApp.models.tasks.Task;
import com.example.GwDanganApp.models.tasks.TaskRequestDto;
import com.example.GwDanganApp.models.users.User;
import com.example.GwDanganApp.services.tasks.TaskService;
import com.example.GwDanganApp.services.users.UserService;

import jakarta.validation.Valid;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {
    
    @Autowired
    private TaskService taskService;

    @Autowired
    private UserService userService;
    
    @GetMapping
    public ResponseEntity<List<Task>> getAllTasks() {
        List<Task> tasks = taskService.getAllTasks();
        if (tasks.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(tasks);

    }

    @GetMapping("/user/{authorId}")
    public ResponseEntity<List<Task>> getTaskByAuthorId(@PathVariable String authorId) {
        try{
        // ユーザーの存在確認(エラースローも含んでる)
        userService.getUserById(authorId);
        
        List<Task> tasks = taskService.getTasksByAuthorId(authorId);
        if (tasks.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(tasks);
        }catch (Exception e) {
            // ユーザーが見つからない場合は404 Not Found
            return ResponseEntity.notFound().build();
        }
    }
    
    @PostMapping
    public ResponseEntity<Task> createTask(@Valid @RequestBody TaskRequestDto task) {
        try {
            User author = userService.getUserById(task.getAuthorId());
            Task newTask = new Task(task.getName(), task.getDescription(), author);
            Task createdTask = taskService.createTask(newTask);
            
            URI location = ServletUriComponentsBuilder
                    .fromCurrentRequest()
                    .path("/{id}")
                    .buildAndExpand(createdTask.getId())
                    .toUri();
            return ResponseEntity.created(location).body(createdTask);
        } catch (Exception e) {
            // ユーザーが見つからない場合は400 Bad Request
            return ResponseEntity.badRequest().build();
        }

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

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        try {
            taskService.deleteTask(id);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
    
}
