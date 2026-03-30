package com.wyh.backend.controller;

import com.wyh.backend.model.Task;
import com.wyh.backend.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tasks")
@CrossOrigin(origins = "*")
public class TaskController {

    @Autowired
    private TaskService taskService;

    @GetMapping
    public ResponseEntity<List<Task>> getAllTasks() {
        return ResponseEntity.ok(taskService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Task> getTask(@PathVariable Long id) {
        return taskService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/appliance/{applianceId}")
    public ResponseEntity<List<Task>> getTasksByApplianceId(@PathVariable Long applianceId) {
        return ResponseEntity.ok(taskService.findByApplianceId(applianceId));
    }

    @PostMapping
    public ResponseEntity<Task> createTask(@RequestBody Task task) {
        Task savedTask = taskService.save(task);
        taskService.scheduleTask(savedTask);
        return ResponseEntity.ok(savedTask);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Task> updateTask(@PathVariable Long id, @RequestBody Task task) {
        return taskService.findById(id)
                .map(existingTask -> {
                    existingTask.setApplianceId(task.getApplianceId());
                    existingTask.setTaskType(task.getTaskType());
                    existingTask.setExecuteTime(task.getExecuteTime());
                    existingTask.setRepeat(task.getRepeat());
                    existingTask.setRepeatDays(task.getRepeatDays());

                    if (task.getCronExpression() != null) {
                        existingTask.setCronExpression(task.getCronExpression());
                    }

                    Task updatedTask = taskService.save(existingTask);
                    taskService.unscheduleTask(id);
                    if (updatedTask.getEnabled()) {
                        taskService.scheduleTask(updatedTask);
                    }
                    return ResponseEntity.ok(updatedTask);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        taskService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/toggle")
    public ResponseEntity<Task> toggleTask(@PathVariable Long id) {
        return taskService.findById(id)
                .map(task -> {
                    taskService.toggleTask(id);
                    return ResponseEntity.ok(task);
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
