package com.wyh.backend.controller;

import com.wyh.backend.model.Task;
import com.wyh.backend.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
    public ResponseEntity<Map<String, Object>> createTask(@RequestBody Map<String, Object> taskData) {
        try {
            System.out.println("=== Creating Task ===");
            System.out.println("Received data: " + taskData);

            Task task = new Task();

            task.setApplianceId(Long.parseLong(taskData.get("applianceId").toString()));
            task.setTaskType(taskData.get("taskType").toString());
            task.setRepeat((Boolean) taskData.get("repeat"));
            task.setEnabled((Boolean) taskData.get("enabled"));

            String executeTimeStr = taskData.get("executeTime").toString();
            System.out.println("Execute time string: " + executeTimeStr);

            LocalDateTime executeTime = parseLocalDateTime(executeTimeStr);
            System.out.println("Parsed execute time: " + executeTime);
            task.setExecuteTime(executeTime);

            // 处理 Cron 表达式（如果前端传了就使用）
            if (taskData.containsKey("cronExpression")) {
                String cronExpr = taskData.get("cronExpression").toString().trim();
                System.out.println("Cron expression: '" + cronExpr + "'");
                task.setCronExpression(cronExpr);
            }

            // 处理重复日期（只有重复任务才需要）
            Boolean repeat = (Boolean) taskData.get("repeat");
            if (repeat != null && repeat) {
                Object repeatDaysObj = taskData.get("repeatDays");
                if (repeatDaysObj != null) {
                    String repeatDays = repeatDaysObj.toString().trim();
                    System.out.println("Repeat days: " + repeatDays);
                    task.setRepeatDays(repeatDays);
                } else {
                    // 如果是重复任务但没有传 repeatDays，默认为每天重复
                    System.out.println("Repeat task without repeatDays, default to daily");
                    task.setRepeatDays("");
                }
            } else {
                // 非重复任务不需要 repeatDays
                task.setRepeatDays(null);
            }

            Task savedTask = taskService.save(task);
            System.out.println("Saved task ID: " + savedTask.getId());

            taskService.scheduleTask(savedTask);
            System.out.println("Task scheduled successfully");

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("task", savedTask);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error creating task: " + e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to add task: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateTask(@PathVariable Long id, @RequestBody Map<String, Object> taskData) {
        try {
            System.out.println("=== Updating Task ===");
            System.out.println("Task ID: " + id);
            System.out.println("Received data: " + taskData);
            
            return taskService.findById(id)
                .map(existingTask -> {
                    existingTask.setApplianceId(Long.parseLong(taskData.get("applianceId").toString()));
                    existingTask.setTaskType(taskData.get("taskType").toString());
                    existingTask.setRepeat((Boolean) taskData.get("repeat"));
                    existingTask.setEnabled((Boolean) taskData.get("enabled"));
                    
                    String executeTimeStr = taskData.get("executeTime").toString();
                    System.out.println("Execute time string: " + executeTimeStr);
                    
                    LocalDateTime executeTime = parseLocalDateTime(executeTimeStr);
                    System.out.println("Parsed execute time: " + executeTime);
                    existingTask.setExecuteTime(executeTime);
                    
                    // 处理 Cron 表达式
                    if (taskData.containsKey("cronExpression")) {
                        String cronExpr = taskData.get("cronExpression").toString().trim();
                        System.out.println("Cron expression: '" + cronExpr + "'");
                        existingTask.setCronExpression(cronExpr);
                    }
                    
                    // 处理重复日期
                    Boolean repeat = (Boolean) taskData.get("repeat");
                    if (repeat != null && repeat) {
                        Object repeatDaysObj = taskData.get("repeatDays");
                        if (repeatDaysObj != null) {
                            String repeatDays = repeatDaysObj.toString().trim();
                            System.out.println("Repeat days: " + repeatDays);
                            existingTask.setRepeatDays(repeatDays);
                        } else {
                            // 重复任务但没有传 repeatDays，默认为每天重复
                            existingTask.setRepeatDays("");
                        }
                    } else {
                        // 非重复任务清空 repeatDays
                        existingTask.setRepeatDays(null);
                    }
                    
                    Task updatedTask = taskService.save(existingTask);
                    System.out.println("Updated task ID: " + updatedTask.getId());
                    
                    // 重新调度任务（即使调度失败也不影响数据更新）
                    try {
                        taskService.unscheduleTask(id);
                        if (updatedTask.getEnabled()) {
                            taskService.scheduleTask(updatedTask);
                        }
                        System.out.println("Task rescheduled successfully");
                    } catch (Exception scheduleException) {
                        System.err.println("Warning: Task updated but scheduling failed: " + scheduleException.getMessage());
                        scheduleException.printStackTrace();
                        // 调度失败不影响数据更新成功的事实
                    }
                    
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", true);
                    response.put("task", updatedTask);
                    response.put("message", "任务更新成功");
                    return ResponseEntity.ok(response);
                })
                .orElse(ResponseEntity.notFound().build());
                
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Failed to update task: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
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

    private LocalDateTime parseLocalDateTime(String dateTimeStr) {
        if (dateTimeStr == null || dateTimeStr.isEmpty()) {
            throw new IllegalArgumentException("Invalid date time string");
        }

        String[] formats = {
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd'T'HH:mm"
        };

        for (String format : formats) {
            try {
                return LocalDateTime.parse(dateTimeStr, DateTimeFormatter.ofPattern(format));
            } catch (Exception e) {
                // Try next format
            }
        }

        throw new IllegalArgumentException("Unable to parse date time: " + dateTimeStr);
    }
}

