package com.example.GwDanganApp.models.tasks;

import com.example.GwDanganApp.models.users.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "tasks")
@Getter
@Setter
@NoArgsConstructor
public class Task {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Task name is required")
    private String name;
    private String description;
    
    @Enumerated(EnumType.STRING)
    private Status status;
    
    @Enumerated(EnumType.STRING)
    private Priority priority;
    
    private Boolean isCompleted;
    
    @ManyToOne
    @JoinColumn(name = "author_id")
    @JsonIgnore
    private User author;

    public Task(String name, String description, User author) {
        this.name = name;
        this.description = description;
        this.author = author;
        this.status = Status.NOT_STARTED;
        this.priority = Priority.LOW;
        this.isCompleted = false;
    }

    public String getAuthorId() {
        return author.getFirebaseUid();
    }

    public String getAuthorName() {
        return author.getName();
    }
}
