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
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .header {
            width: 100%;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 15px 20px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .header h1 {
            margin: 0 0 15px 0;
            color: #333;
        }
        .nav-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }
        .nav {
            display: flex;
            gap: 30px;
        }
        .nav a {
            color: #007BFF;
            text-decoration: none;
            font-weight: bold;
            padding: 8px 16px;
            border-radius: 4px;
            transition: background-color 0.3s;
            white-space: nowrap;
        }
        .nav a:hover {
            background-color: rgba(0, 123, 255, 0.1);
        }
        .nav a.active {
            background-color: #007BFF;
            color: white;
        }
        .logout-btn {
            color: #007BFF;
            text-decoration: none;
            font-weight: bold;
            white-space: nowrap;
        }
        .container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 900px;
            margin-bottom: 40px;
            position: relative;
        }
        .add-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }
        .add-btn:hover {
            background-color: #218838;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        .action-btn {
            padding: 6px 12px;
            margin-right: 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        .edit-btn {
            background-color: #28a745;
            color: white;
        }
        .edit-btn:hover {
            background-color: #218838;
        }
        .delete-btn {
            background-color: #dc3545;
            color: white;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }
        .toggle-btn {
            background-color: #007BFF;
            color: white;
        }
        .toggle-btn:hover {
            background-color: #0056b3;
        }
        .empty-message {
            text-align: center;
            color: #666;
            padding: 20px;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-enabled {
            background-color: #28a745;
            color: white;
        }
        .status-disabled {
            background-color: #dc3545;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>任务管理</h1>
        <div class="nav-container">
            <div class="nav">
                <a href="${pageContext.request.contextPath}/appliances">电器设备</a>
                <a href="${pageContext.request.contextPath}/tasks" class="active">任务</a>
                <a href="${pageContext.request.contextPath}/home">用户</a>
                <a href="${pageContext.request.contextPath}/log">日志</a>
            </div>
            <a href="${pageContext.request.contextPath}/login" class="logout-btn">退出登录</a>
        </div>
    </div>

    <div class="container">
        <h2>任务列表</h2>
        <a href="${pageContext.request.contextPath}/taskedit" class="add-btn">添加任务</a>
        <p id="debugInfo" style="color: blue; font-size: 12px;"></p>
        <table id="taskTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>电器</th>
                    <th>类型</th>
                    <th>执行时间</th>
                    <th>重复</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody id="taskTableBody">
            </tbody>
        </table>
        <div id="emptyMessage" class="empty-message" style="display: none;">暂无任务</div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const API_BASE_URL = contextPath + '/api/tasks';
        const APPLIANCE_API_URL = contextPath + '/api/appliances';
        let appliancesCache = [];

        console.log('=== Task Management Page ===');
        console.log('API Base URL:', API_BASE_URL);

        function loadAppliances() {
            return fetch(APPLIANCE_API_URL)
                .then(response => response.json())
                .then(appliances => {
                    appliancesCache = appliances;
                    console.log('Appliances loaded:', appliances);
                    return appliances;
                });
        }

        function getApplianceName(applianceId) {
            console.log('Looking for applianceId:', applianceId, 'type:', typeof applianceId);
            console.log('Cache:', appliancesCache);

            if (!applianceId) {
                return 'No Appliance';
            }

            const appliance = appliancesCache.find(a => {
                console.log('Comparing - a.id:', a.id, 'type:', typeof a.id, 'with:', applianceId, 'match:', a.id == applianceId);
                return a.id == applianceId;
            });

            if (appliance) {
                return (appliance.name || '') + (appliance.location || '');
            }
            return 'Unknown (' + applianceId + ')';
        }

        function formatDateTime(dateTimeStr) {
            if (!dateTimeStr) return 'N/A';
            const date = new Date(dateTimeStr);
            return date.toLocaleString('en-US', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        function formatRepeat(repeat, repeatDays) {
            if (!repeat) return 'One-time';
            if (!repeatDays) return 'Daily';
            const daysMap = {
                'MON': 'Mon', 'TUE': 'Tue', 'WED': 'Wed', 'THU': 'Thu',
                'FRI': 'Fri', 'SAT': 'Sat', 'SUN': 'Sun'
            };
            const days = repeatDays.split(',').map(d => daysMap[d] || d);
            return days.join(', ');
        }

        function renderTable() {
            const debugInfo = document.getElementById('debugInfo');
            debugInfo.textContent = 'Loading...';

            loadAppliances().then(() => {
                fetch(API_BASE_URL, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    return response.json();
                })
                .then(tasks => {
                    debugInfo.textContent = 'Loaded ' + tasks.length + ' tasks successfully!';

                    const tbody = document.getElementById('taskTableBody');
                    const emptyMsg = document.getElementById('emptyMessage');

                    tbody.innerHTML = '';
                    tbody.style.display = 'table-row-group';

                    if (tasks.length === 0) {
                        emptyMsg.style.display = 'block';
                        document.getElementById('taskTable').style.display = 'none';
                        return;
                    } else {
                        emptyMsg.style.display = 'none';
                        document.getElementById('taskTable').style.display = 'table';
                    }

                    tasks.forEach(task => {
                        const tr = document.createElement('tr');

                        const taskId = task.id || '-';
                        const applianceName = getApplianceName(task.applianceId);
                        const taskType = task.taskType || 'N/A';
                        const executeTime = formatDateTime(task.executeTime);
                        const repeat = formatRepeat(task.repeat, task.repeatDays);
                        const enabled = task.enabled !== false;

                        tr.innerHTML = '<td>' + taskId + '</td>' +
                                       '<td>' + applianceName + '</td>' +
                                       '<td>' + taskType + '</td>' +
                                       '<td>' + executeTime + '</td>' +
                                       '<td>' + repeat + '</td>' +
                                       '<td><span class="status-badge ' + (enabled ? 'status-enabled' : 'status-disabled') + '">' + (enabled ? '启用' : '禁用') + '</span></td>' +
                                       '<td>' +
                                       '<button class="action-btn toggle-btn" onclick="toggleTask(' + taskId + ', ' + enabled + ')">' + (enabled ? '禁用' : '启用') + '</button>' +
                                       '<button class="action-btn edit-btn" onclick="editTask(' + taskId + ')">编辑</button>' +
                                       '<button class="action-btn delete-btn" onclick="deleteTask(' + taskId + ')">删除</button>' +
                                       '</td>';
                        tbody.appendChild(tr);
                    });

                    console.log('Table rendered successfully');
                })
                .catch(error => {
                    console.error('Error fetching tasks:', error);
                    debugInfo.textContent = '错误：' + error.message;
                    alert('加载任务失败：' + error.message);
                });

            }).catch(error => {
                console.error('Error loading appliances:', error);
            });
        }

        window.deleteTask = function(id) {
            if (confirm('确定要删除这个任务吗？')) {
                const deleteUrl = API_BASE_URL + '/' + id;
                console.log('Deleting task with ID:', id);

                fetch(deleteUrl, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        renderTable();
                        alert('任务删除成功');
                    } else if (response.status === 404) {
                        alert('任务不存在。');
                        renderTable();
                    } else {
                        alert('删除失败');
                    }
                })
                .catch(error => {
                    console.error('Error deleting task:', error);
                    alert('删除任务出错：' + error.message);
                });
            }
        };

        window.toggleTask = function(id, enabled) {
            const toggleUrl = API_BASE_URL + '/' + id + '/toggle';
            console.log('Toggling task ID:', id, 'Current enabled:', enabled);

            fetch(toggleUrl, {
                method: 'PUT'
            })
            .then(response => {
                if (response.ok) {
                    renderTable();
                    const newStatus = !enabled;
                    alert('任务已' + (newStatus ? '启用' : '禁用'));
                } else {
                    alert('切换失败');
                }
            })
            .catch(error => {
                console.error('Error toggling task:', error);
                alert('出错：' + error.message);
            });
        };

        window.editTask = function(id) {
            console.log('Editing task with ID:', id);
            window.location.href = contextPath + '/taskedit?id=' + id;
        };

        console.log('=== Page Loaded ===');
        renderTable();
    </script>
</body>
</html>
