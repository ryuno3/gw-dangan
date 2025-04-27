package com.example.GwDanganApp.models.tasks;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "tasks")
@Getter
@Setter
@NoArgsConstructor
public class Task {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String description;
    
    @Enumerated(EnumType.STRING)
    private Status status;
    
    @Enumerated(EnumType.STRING)
    private Priority priority;
    
    private Boolean isCompleted;

    public Task(String name, String description) {
        this.name = name;
        this.description = description;
        this.status = Status.NOT_STARTED;
        this.priority = Priority.LOW;
        this.isCompleted = false;
    }
}
