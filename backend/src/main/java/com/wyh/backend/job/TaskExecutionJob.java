package com.wyh.backend.job;

import com.wyh.backend.service.TaskService;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class TaskExecutionJob implements Job {

    @Autowired
    private TaskService taskService;

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        Long taskId = context.getMergedJobDataMap().getLong("taskId");
        Long applianceId = context.getMergedJobDataMap().getLong("applianceId");
        String taskType = context.getMergedJobDataMap().getString("taskType");

        System.out.println("执行定时任务：" + taskId + ", 电器 ID: " + applianceId + ", 操作：" + taskType);

        taskService.executeTask(applianceId, taskType);
    }
}
