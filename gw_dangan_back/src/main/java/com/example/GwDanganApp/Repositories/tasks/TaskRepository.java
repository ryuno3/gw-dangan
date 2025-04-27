package com.example.GwDanganApp.Repositories.tasks;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.GwDanganApp.models.tasks.Task;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {

    // 基本的なCRUD操作はJpaRepositoryで提供されます
    // 必要に応じてカスタムクエリメソッドを追加できます
}
