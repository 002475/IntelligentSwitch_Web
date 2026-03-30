package com.wyh.backend.repository;

import com.wyh.backend.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByApplianceId(Long applianceId);
    List<Task> findByEnabledTrue();
    List<Task> findByApplianceIdAndEnabled(Long applianceId, Boolean enabled);
}
