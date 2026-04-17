package com.wyh.backend.service;

import com.wyh.backend.job.TaskExecutionJob;
import com.wyh.backend.model.Task;
import com.wyh.backend.repository.TaskRepository;
import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private Scheduler scheduler;

    @Autowired
    private ElectricalApplianceService applianceService;

    public List<Task> findAll() {
        return taskRepository.findAll();
    }

    public List<Task> findByApplianceId(Long applianceId) {
        return taskRepository.findByApplianceId(applianceId);
    }

    public List<Task> findEnabledTasks() {
        return taskRepository.findByEnabledTrue();
    }

    public Optional<Task> findById(Long id) {
        return taskRepository.findById(id);
    }

    public List<Task> searchTasks(String keyword) {
        return taskRepository.findAll().stream()
            .filter(task -> 
                (task.getTaskType() != null && task.getTaskType().contains(keyword)) ||
                (task.getCronExpression() != null && task.getCronExpression().contains(keyword))
            )
            .collect(Collectors.toList());
    }

    @Transactional
    public Task save(Task task) {
        if (task.getCronExpression() == null && task.getExecuteTime() != null) {
            LocalDateTime time = task.getExecuteTime();
            String cron = generateCronExpression(time, task.getRepeat(), task.getRepeatDays());
            task.setCronExpression(cron);
            System.out.println("Generated cron expression: " + cron);
        }
        return taskRepository.save(task);
    }

    private String generateCronExpression(LocalDateTime time, Boolean repeat, String repeatDays) {
        if (repeat != null && repeat && repeatDays != null && !repeatDays.trim().isEmpty()) {
            String[] days = repeatDays.split(",");
            StringBuilder dayNumbers = new StringBuilder();
            
            for (int i = 0; i < days.length; i++) {
                String day = days[i].trim().toUpperCase();
                String dayNum = switch (day) {
                    case "SUN" -> "1";
                    case "MON" -> "2";
                    case "TUE" -> "3";
                    case "WED" -> "4";
                    case "THU" -> "5";
                    case "FRI" -> "6";
                    case "SAT" -> "7";
                    default -> "";
                };
                
                if (!dayNum.isEmpty()) {
                    if (dayNumbers.length() > 0) {
                        dayNumbers.append(",");
                    }
                    dayNumbers.append(dayNum);
                }
            }
            
            if (dayNumbers.length() == 0) {
                System.out.println("No valid repeat days, using daily repetition");
                return String.format("%d %d %d * * ?", 
                        time.getSecond(),
                        time.getMinute(),
                        time.getHour());
            }
            
            String cron = String.format("%d %d %d ? * %s", 
                    time.getSecond(),
                    time.getMinute(),
                    time.getHour(),
                    dayNumbers.toString());
            System.out.println("Weekly repetition cron: " + cron);
            return cron;
            
        } else {
            String cron = String.format("%d %d %d * * ?", 
                    time.getSecond(),
                    time.getMinute(),
                    time.getHour());
            System.out.println("Daily repetition cron: " + cron);
            return cron;
        }
    }

    @Transactional
    public void deleteById(Long id) {
        try {
            JobKey jobKey = JobKey.jobKey("task_" + id);
            if (scheduler.checkExists(jobKey)) {
                scheduler.deleteJob(jobKey);
            }
        } catch (SchedulerException e) {
            throw new RuntimeException("删除定时任务失败", e);
        }
        taskRepository.deleteById(id);
    }

    @Transactional
    public void scheduleTask(Task task) {
        try {
            if (task.getCronExpression() == null || task.getCronExpression().trim().isEmpty()) {
                throw new RuntimeException("Cron expression is required");
            }
            
            String cronExpr = task.getCronExpression().trim();
            System.out.println("Scheduling task with cron: '" + cronExpr + "'");
            
            JobDataMap jobDataMap = new JobDataMap();
            jobDataMap.put("taskId", task.getId());
            jobDataMap.put("applianceId", task.getApplianceId());
            jobDataMap.put("taskType", task.getTaskType());

            JobDetail jobDetail = JobBuilder.newJob(TaskExecutionJob.class)
                    .withIdentity("task_" + task.getId(), "tasks")
                    .usingJobData(jobDataMap)
                    .build();

            CronTrigger trigger = TriggerBuilder.newTrigger()
                    .withIdentity("trigger_" + task.getId(), "tasks")
                    .withSchedule(CronScheduleBuilder.cronSchedule(cronExpr))
                    .build();

            scheduler.scheduleJob(jobDetail, trigger);
            System.out.println("Task scheduled successfully!");
        } catch (SchedulerException e) {
            throw new RuntimeException("调度任务失败：" + e.getMessage(), e);
        } catch (Exception e) {
            throw new RuntimeException("创建定时任务失败：" + e.getMessage(), e);
        }
    }

    @Transactional
    public void unscheduleTask(Long taskId) {
        try {
            JobKey jobKey = JobKey.jobKey("task_" + taskId);
            if (scheduler.checkExists(jobKey)) {
                scheduler.deleteJob(jobKey);
            }
        } catch (SchedulerException e) {
            throw new RuntimeException("取消调度任务失败", e);
        }
    }

    @Transactional
    public void toggleTask(Long id) {
        Optional<Task> taskOpt = taskRepository.findById(id);
        if (taskOpt.isPresent()) {
            Task task = taskOpt.get();
            task.setEnabled(!task.getEnabled());
            taskRepository.save(task);

            if (task.getEnabled()) {
                scheduleTask(task);
            } else {
                unscheduleTask(id);
            }
        }
    }

    public void executeTask(Long applianceId, String taskType) {
        applianceService.findById(applianceId).ifPresent(appliance -> {
            if ("ON".equals(taskType)) {
                appliance.setStatus(true);
            } else if ("OFF".equals(taskType)) {
                appliance.setStatus(false);
            }
            applianceService.update(appliance);
        });
    }
}
