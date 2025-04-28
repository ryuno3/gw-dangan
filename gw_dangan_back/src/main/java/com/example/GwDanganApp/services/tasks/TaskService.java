package com.example.GwDanganApp.services.tasks;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.GwDanganApp.Repositories.tasks.TaskRepository;
import com.example.GwDanganApp.models.tasks.Priority;
import com.example.GwDanganApp.models.tasks.Status;
import com.example.GwDanganApp.models.tasks.Task;
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
        if (task.getStatus() == null) {
            task.setStatus(Status.NOT_STARTED);
        }
        if (task.getPriority() == null) {
            task.setPriority(Priority.LOW);
        }
        if (task.getIsCompleted() == null) {
            task.setIsCompleted(false);
        }
        return taskRepository.save(task);
    }
}
