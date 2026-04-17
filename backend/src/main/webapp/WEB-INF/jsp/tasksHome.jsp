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
        .add-btn.disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }
        .search-box {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
        .search-box input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .search-box button {
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        .search-box button:hover {
            background-color: #0056b3;
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
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="搜索任务类型或Cron表达式...">
            <button onclick="searchTasks()">搜索</button>
            <button onclick="loadAllTasks()" style="background-color: #6c757d;">重置</button>
        </div>
        <a href="${pageContext.request.contextPath}/taskedit" class="add-btn" id="addBtn">添加任务</a>
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

        const currentUser = JSON.parse(sessionStorage.getItem('currentUser') || '{}');
        const isAdmin = currentUser.role === 'ADMIN';

        console.log('Current User:', currentUser);
        console.log('Is Admin:', isAdmin);

        if (!isAdmin) {
            const addBtn = document.getElementById('addBtn');
            addBtn.classList.add('disabled');
            addBtn.onclick = function(e) {
                e.preventDefault();
                alert('只有管理员可以添加任务');
            };
        }

        function loadAppliances() {
            return fetch(APPLIANCE_API_URL)
                .then(response => response.json())
                .then(appliances => {
                    appliancesCache = appliances;
                    return appliances;
                });
        }

        function getApplianceName(applianceId) {
            if (!applianceId) {
                return '无电器设备';
            }

            const appliance = appliancesCache.find(a => a.id == applianceId);

            if (appliance) {
                return (appliance.name || '') + (appliance.location || '');
            }
            return '未知 (' + applianceId + ')';
        }

        function formatDateTime(dateTimeStr) {
            if (!dateTimeStr) return '暂无';
            const date = new Date(dateTimeStr);
            return date.toLocaleString('zh-CN', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        function formatRepeat(repeat, repeatDays) {
            if (!repeat) return '一次性任务';
            if (!repeatDays) return '每天重复';
            const daysMap = {
                'MON': '周一', 'TUE': '周二', 'WED': '周三', 'THU': '周四',
                'FRI': '周五', 'SAT': '周六', 'SUN': '周日'
            };
            const days = repeatDays.split(',').map(d => daysMap[d] || d);
            return days.join(', ');
        }

        function renderTable(tasks) {
            const debugInfo = document.getElementById('debugInfo');
            debugInfo.textContent = '已加载 ' + tasks.length + ' 个任务';

            const tbody = document.getElementById('taskTableBody');
            const emptyMsg = document.getElementById('emptyMessage');

            tbody.innerHTML = '';

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
                const taskType = task.taskType || '暂无';
                const executeTime = formatDateTime(task.executeTime);
                const repeat = formatRepeat(task.repeat, task.repeatDays);
                const enabled = task.enabled !== false;

                let actionButtons = '<button class="action-btn toggle-btn" onclick="toggleTask(' + taskId + ', ' + enabled + ')">' + (enabled ? '禁用' : '启用') + '</button>';

                if (isAdmin) {
                    actionButtons += '<button class="action-btn edit-btn" onclick="editTask(' + taskId + ')">编辑</button>' +
                                    '<button class="action-btn delete-btn" onclick="deleteTask(' + taskId + ')">删除</button>';
                }

                tr.innerHTML = '<td>' + taskId + '</td>' +
                               '<td>' + applianceName + '</td>' +
                               '<td>' + taskType + '</td>' +
                               '<td>' + executeTime + '</td>' +
                               '<td>' + repeat + '</td>' +
                               '<td><span class="status-badge ' + (enabled ? 'status-enabled' : 'status-disabled') + '">' + (enabled ? '启用' : '禁用') + '</span></td>' +
                               '<td>' + actionButtons + '</td>';
                tbody.appendChild(tr);
            });
        }

        function loadAllTasks() {
            document.getElementById('searchInput').value = '';
            loadAppliances().then(() => {
                fetch(API_BASE_URL)
                .then(response => response.json())
                .then(tasks => {
                    renderTable(tasks);
                })
                .catch(error => {
                    console.error('获取任务时出错:', error);
                    alert('加载任务失败：' + error.message);
                });
            });
        }

        window.searchTasks = function() {
            const keyword = document.getElementById('searchInput').value.trim();
            if (!keyword) {
                loadAllTasks();
                return;
            }

            loadAppliances().then(() => {
                fetch(API_BASE_URL + '/search?keyword=' + encodeURIComponent(keyword))
                .then(response => response.json())
                .then(tasks => {
                    renderTable(tasks);
                })
                .catch(error => {
                    console.error('搜索任务时出错:', error);
                    alert('搜索失败：' + error.message);
                });
            });
        };

        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchTasks();
            }
        });

        window.deleteTask = function(id) {
            if (!isAdmin) {
                alert('只有管理员可以删除任务');
                return;
            }

            if (confirm('确定要删除这个任务吗？')) {
                fetch(API_BASE_URL + '/' + id, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ isAdmin: true })
                })
                .then(response => {
                    if (response.ok) {
                        loadAllTasks();
                        alert('任务删除成功');
                    } else {
                        return response.json().then(err => {
                            throw new Error(err.message || '删除失败');
                        });
                    }
                })
                .catch(error => {
                    console.error('删除任务时出错:', error);
                    alert('删除任务出错：' + error.message);
                });
            }
        };

        window.toggleTask = function(id, enabled) {
            fetch(API_BASE_URL + '/' + id + '/toggle', {
                method: 'PUT'
            })
            .then(response => {
                if (response.ok) {
                    loadAllTasks();
                    const newStatus = !enabled;
                    alert('任务已' + (newStatus ? '启用' : '禁用'));
                } else {
                    alert('切换失败');
                }
            })
            .catch(error => {
                console.error('切换任务状态时出错:', error);
                alert('出错：' + error.message);
            });
        };

        window.editTask = function(id) {
            if (!isAdmin) {
                alert('只有管理员可以编辑任务');
                return;
            }
            window.location.href = contextPath + '/taskedit?id=' + id;
        };

        loadAllTasks();
    </script>
</body>
</html>
