<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-image: url("${pageContext.request.contextPath}/images/login_register_bg.png");
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .edit-container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 450px;
            max-height: 90vh;
            overflow-y: auto;
        }
        .edit-form {
            display: flex;
            flex-direction: column;
        }
        .edit-form label {
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .edit-form input, .edit-form select {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        .edit-form input:focus, .edit-form select:focus {
            outline: none;
            border-color: #007BFF;
        }
        .edit-form select {
            color: #666;
        }
        .edit-form select:valid {
            color: #333;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .checkbox-group input[type="checkbox"] {
            margin-right: 10px;
            width: 18px;
            height: 18px;
        }
        .checkbox-group label {
            margin-bottom: 0;
            font-weight: normal;
        }
        .repeat-days-group {
            display: none;
            margin-bottom: 15px;
        }
        .repeat-days-group.show {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .day-checkbox {
            display: flex;
            align-items: center;
            background-color: #f8f9fa;
            padding: 8px 12px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }
        .day-checkbox input[type="checkbox"] {
            margin-right: 5px;
            width: 16px;
            height: 16px;
        }
        .day-checkbox label {
            margin-bottom: 0;
            font-size: 13px;
            cursor: pointer;
        }
        .btn-group {
            display: flex;
            justify-content: space-between;
        }
        .edit-form button {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            color: white;
            flex: 1;
            margin: 0 5px;
            font-weight: bold;
        }
        .save-btn {
            background-color: #28a745;
        }
        .save-btn:hover {
            background-color: #218838;
        }
        .cancel-btn {
            background-color: #6c757d;
        }
        .cancel-btn:hover {
            background-color: #5a6268;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }
        .form-title {
            font-size: 18px;
            margin-bottom: 10px;
            color: #007BFF;
        }
        .time-input-group {
            display: flex;
            gap: 10px;
        }
        .time-input-group input {
            flex: 1;
        }
    </style>
</head>
<body>
    <div class="edit-container">
        <h2 id="pageHeader">添加任务</h2>
        <div class="form-title" id="formTitle" style="display: none;"></div>
        <form class="edit-form" id="editForm">
            <input type="hidden" id="taskId">

            <label for="applianceSelect">电器设备：</label>
            <select id="applianceSelect" required>
                <option value="" disabled selected>请选择电器</option>
            </select>

            <label for="taskType">任务类型：</label>
            <select id="taskType" required>
                <option value="" disabled selected>请选择操作</option>
                <option value="ON">开启</option>
                <option value="OFF">关闭</option>
            </select>

            <label for="executeDate">执行日期：</label>
            <input type="date" id="executeDate" required>

            <label for="executeTime">执行时间：</label>
            <div class="time-input-group">
                <input type="time" id="executeTime" required>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="repeatCheckbox">
                <label for="repeatCheckbox">重复任务</label>
            </div>

            <div class="repeat-days-group" id="repeatDaysGroup">
                <div class="day-checkbox">
                    <input type="checkbox" id="dayMon" value="MON">
                    <label for="dayMon">一</label>
                </div>
                <div class="day-checkbox">
                    <input type="checkbox" id="dayTue" value="TUE">
                    <label for="dayTue">二</label>
                </div>
                <div class="day-checkbox">
                    <input type="checkbox" id="dayWed" value="WED">
                    <label for="dayWed">三</label>
                </div>
                <div class="day-checkbox">
                    <input type="checkbox" id="dayThu" value="THU">
                    <label for="dayThu">四</label>
                </div>
                <div class="day-checkbox">
                    <input type="checkbox" id="dayFri" value="FRI">
                    <label for="dayFri">五</label>
                </div>
                <div class="day-checkbox">
                    <input type="checkbox" id="daySat" value="SAT">
                    <label for="daySat">六</label>
                </div>
                <div class="day-checkbox">
                    <input type="checkbox" id="daySun" value="SUN">
                    <label for="daySun">日</label>
                </div>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="enabledCheckbox" checked>
                <label for="enabledCheckbox">启用</label>
            </div>

            <div class="btn-group">
                <button type="button" class="cancel-btn" onclick="window.location.href='${pageContext.request.contextPath}/tasks'">取消</button>
                <button type="submit" class="save-btn">保存</button>
            </div>
        </form>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const API_BASE_URL = contextPath + '/api/tasks';
        const APPLIANCE_API_URL = contextPath + '/api/appliances';
        let isEditMode = false;

        console.log('Task Edit Page Debug:');
        console.log('Context Path:', contextPath);
        console.log('Task API Base URL:', API_BASE_URL);
        console.log('Appliance API Base URL:', APPLIANCE_API_URL);
        console.log('Current URL:', window.location.href);

        window.addEventListener('DOMContentLoaded', () => {
            loadAppliances();

            const repeatCheckbox = document.getElementById('repeatCheckbox');
            const repeatDaysGroup = document.getElementById('repeatDaysGroup');

            repeatCheckbox.addEventListener('change', function() {
                if (this.checked) {
                    repeatDaysGroup.classList.add('show');
                } else {
                    repeatDaysGroup.classList.remove('show');
                }
            });

            const urlParams = new URLSearchParams(window.location.search);
            const taskId = urlParams.get('id');

            console.log('Task ID from URL:', taskId);

            if (taskId) {
                isEditMode = true;
                document.getElementById('pageHeader').textContent = '编辑任务';
                loadTask(taskId);
            } else {
                isEditMode = false;
                document.getElementById('pageHeader').textContent = '添加任务';
                setDefaultDateTime();
            }
        });

        function setDefaultDateTime() {
            const now = new Date();
            const dateStr = now.toISOString().split('T')[0];
            const timeStr = now.toTimeString().split(' ')[0].slice(0, 5);

            document.getElementById('executeDate').value = dateStr;
            document.getElementById('executeTime').value = timeStr;
        }

        function loadAppliances() {
            fetch(APPLIANCE_API_URL)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to load appliances');
                    }
                    return response.json();
                })
                .then(appliances => {
                    const select = document.getElementById('applianceSelect');
                    appliances.forEach(appliance => {
                        const option = document.createElement('option');
                        option.value = appliance.id;
                        option.textContent = (appliance.name || '') + (appliance.location || '');
                        select.appendChild(option);
                    });
                    console.log('Appliances loaded:', appliances.length);
                })
                .catch(error => {
                    console.error('Error loading appliances:', error);
                    alert('加载电器列表失败');
                });
        }

        function loadTask(taskId) {
            const fetchUrl = API_BASE_URL + '/' + taskId;
            console.log('Fetching task from:', fetchUrl);

            fetch(fetchUrl)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Task not found');
                    }
                    return response.json();
                })
                .then(task => {
                    console.log('Task data loaded:', task);
                    document.getElementById('taskId').value = task.id;
                    document.getElementById('applianceSelect').value = task.applianceId;
                    document.getElementById('taskType').value = task.taskType;

                    if (task.executeTime) {
                        const executeDateTime = new Date(task.executeTime);
                        const dateStr = executeDateTime.toISOString().split('T')[0];
                        const timeStr = executeDateTime.toTimeString().split(' ')[0].slice(0, 5);
                        document.getElementById('executeDate').value = dateStr;
                        document.getElementById('executeTime').value = timeStr;
                    }

                    document.getElementById('repeatCheckbox').checked = task.repeat || false;

                    if (task.repeat && task.repeatDays) {
                        const days = task.repeatDays.split(',');
                        days.forEach(day => {
                            const checkbox = document.querySelector(`input[value="${day}"]`);
                            if (checkbox) {
                                checkbox.checked = true;
                            }
                        });
                        document.getElementById('repeatDaysGroup').classList.add('show');
                    }

                    document.getElementById('enabledCheckbox').checked = task.enabled !== false;
                })
                .catch(error => {
                    console.error('Error fetching task:', error);
                    alert('任务不存在。错误：' + error.message);
                    window.location.href = contextPath + '/tasks';
                });
        }

        function getCronExpression(date, time, repeat, repeatDays) {
            const [hour, minute] = time.split(':');
            const second = '0';

            if (repeat && repeatDays && repeatDays.length > 0) {
                const daysMap = {
                    'SUN': '1', 'MON': '2', 'TUE': '3', 'WED': '4',
                    'THU': '5', 'FRI': '6', 'SAT': '7'
                };

                const dayNumbers = [];
                for (let i = 0; i < repeatDays.length; i++) {
                    const day = repeatDays[i].trim().toUpperCase();
                    if (daysMap[day]) {
                        dayNumbers.push(daysMap[day]);
                    }
                }

                if (dayNumbers.length > 0) {
                    dayNumbers.sort((a, b) => parseInt(a) - parseInt(b));
                    return second + ' ' + minute + ' ' + hour + ' ? * ' + dayNumbers.join(',');
                }
            }

            // 非重复任务：每天相同时间执行
            return second + ' ' + minute + ' ' + hour + ' * * ?';
        }

        document.getElementById('editForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const taskId = document.getElementById('taskId').value;
            const applianceId = parseInt(document.getElementById('applianceSelect').value);
            const taskType = document.getElementById('taskType').value.trim();
            const executeDate = document.getElementById('executeDate').value;
            const executeTime = document.getElementById('executeTime').value;
            const repeat = document.getElementById('repeatCheckbox').checked;
            const enabled = document.getElementById('enabledCheckbox').checked;

            if (!applianceId) {
                alert('请选择电器设备。');
                return;
            }

            if (!taskType) {
                alert('请选择任务类型。');
                return;
            }

            if (!executeDate || !executeTime) {
                alert('请设置执行日期和时间。');
                return;
            }

            let repeatDays = null;
            if (repeat) {
                const selectedDays = [];

                // 直接通过 ID 获取每个星期的 checkbox
                const dayIds = ['dayMon', 'dayTue', 'dayWed', 'dayThu', 'dayFri', 'daySat', 'daySun'];
                const dayValues = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

                for (let i = 0; i < dayIds.length; i++) {
                    const checkbox = document.getElementById(dayIds[i]);
                    console.log('Checking checkbox ID:', dayIds[i], ', Element:', checkbox, ', Checked:', checkbox ? checkbox.checked : 'N/A');

                    if (checkbox && checkbox.checked) {
                        selectedDays.push(dayValues[i]);
                        console.log('Added day:', dayValues[i]);
                    }
                }

                console.log('Selected days array:', selectedDays);

                if (selectedDays.length === 0) {
                    console.warn('No days selected for repeat task');
                    alert('请至少选择一天作为重复任务的执行日期。');
                    return;
                }
                repeatDays = selectedDays.join(',');
            }

            // 直接使用用户选择的日期和时间，避免时区转换问题
            const formattedDateTime = executeDate + ' ' + executeTime + ':00';

            const cronExpression = getCronExpression(null, executeTime, repeat, repeat ? repeatDays : null);

            console.log('Execute DateTime:', formattedDateTime);
            console.log('Cron Expression:', cronExpression);
            console.log('Repeat:', repeat);
            console.log('Repeat Days:', repeatDays);

            const taskData = {
                applianceId: applianceId,
                taskType: taskType,
                executeTime: formattedDateTime,
                repeat: repeat,
                enabled: enabled
            };

            // 总是传递 repeatDays 字段，即使是空字符串
            if (repeat) {
                taskData.repeatDays = repeatDays || '';
            }

            // 如果前端已经计算了 Cron，也传过去（可选）
            if (cronExpression) {
                taskData.cronExpression = cronExpression;
            }

            if (isEditMode && taskId) {
                const updateUrl = API_BASE_URL + '/' + taskId;
                console.log('Updating task at:', updateUrl);

                fetch(updateUrl, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(taskData)
                })
                .then(response => {
                    console.log('Update response status:', response.status);
                    if (response.ok) {
                        alert('任务更新成功！');
                        window.location.href = contextPath + '/tasks';
                    } else if (response.status === 404) {
                        alert('任务不存在。');
                    } else {
                        alert('更新失败，请重试。');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('更新失败，请重试。');
                });
            } else {
                console.log('Creating new task');

                fetch(API_BASE_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(taskData)
                })
                .then(response => {
                    console.log('Create response status:', response.status);
                    if (response.ok) {
                        alert('任务添加成功！');
                        window.location.href = contextPath + '/tasks';
                    } else {
                        alert('添加失败，请重试。');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('添加失败，请重试。');
                });
            }
        });
    </script>
</body>
</html>
