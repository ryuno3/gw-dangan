package com.example.GwDanganApp.models.tasks;

public class Task {
    private String name;
    private String description;
    private Status status ;
    private Priority priority;
    private Boolean isCompleted;

    public Task(String name, String description){
        this.name = name;
        this.description = description;
        this.status = Status.NOT_STARTED;
        this.priority = Priority.LOW;
        this.isCompleted = false;
    }

    // Getters 
    public String getName() {
        return name;
    }
    public String getDescription() {
        return description;
    }
    public Status getStatus() {
        return status;
    }
    public Priority getPriority() {
        return priority;
    }
    public Boolean getIsCompleted() {
        return isCompleted;
    }

    // Setters
    public void setName(String name) {
        this.name = name;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public void setStatus(Status status) {
        this.status = status;
    }
    public void setPriority(Priority priority) {
        this.priority = priority;
    }
    public void setIsCompleted(Boolean isCompleted) {
        this.isCompleted = isCompleted;
    }
}
