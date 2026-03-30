package com.wyh.backend.service;

import com.wyh.backend.job.TaskExecutionJob;
import com.wyh.backend.model.Task;
import com.wyh.backend.repository.TaskRepository;
import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

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

    @Transactional
    public Task save(Task task) {
        if (task.getCronExpression() == null && task.getExecuteTime() != null) {
            String cron = String.format("%d %d %d * * ?",
                    task.getExecuteTime().getSecond(),
                    task.getExecuteTime().getMinute(),
                    task.getExecuteTime().getHour());
            task.setCronExpression(cron);
        }
        return taskRepository.save(task);
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
                    .withSchedule(CronScheduleBuilder.cronSchedule(task.getCronExpression()))
                    .build();

            scheduler.scheduleJob(jobDetail, trigger);
        } catch (SchedulerException e) {
            throw new RuntimeException("调度任务失败", e);
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
