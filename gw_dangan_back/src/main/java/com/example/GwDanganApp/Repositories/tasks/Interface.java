package com.example.GwDanganApp.Repositories.tasks;

import java.util.List;

import com.example.GwDanganApp.models.tasks.Task;

public interface Interface {
    // Define the methods that will be implemented by the repository classes
    void addTask(Task task);
    Task getTaskById(int taskId);
    List<Task> getAllTasks();
}
