package com.example.GwDanganApp.models.tasks;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class TaskRequestDto {
    
    @NotBlank(message = "Task name is required")
    private String name;
    @NotBlank(message = "Task description is required")
    private String description;
    @NotNull(message = "author id is required")
    @NotBlank(message = "author id cannot be blank")
    private String authorId;
}
