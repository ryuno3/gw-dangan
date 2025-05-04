package com.example.GwDanganApp.services.tasks;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.GwDanganApp.models.tasks.Task;
import com.example.GwDanganApp.repositories.task.TaskRepository;
import com.example.GwDanganApp.utils.error.tasks.TaskNotFoundException;

@Service
public class TaskService {
    
    @Autowired
    private TaskRepository taskRepository;

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public Task getTaskById(Long id){
        return taskRepository.findById(id)
                .orElseThrow(() -> new TaskNotFoundException("Task not found with id: " + id));
    }

    public Task createTask(Task task) {
        return taskRepository.save(task);
    }

    public void deleteTask(Long id) {
        Task task = getTaskById(id);
        if (task == null) {
            // レスポンスボディにエラーメッセージを含める
            
            throw new TaskNotFoundException("Task not found with id: " + id);
        }
        taskRepository.delete(task);
    }
}
