<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Home</title>
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
            max-width: 800px;
            margin-bottom: 40px;
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
        .empty-message {
            text-align: center;
            color: #666;
            padding: 20px;
        }
        .role-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .role-admin {
            background-color: #dc3545;
            color: white;
        }
        .role-user {
            background-color: #28a745;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>用户管理</h1>
        <div class="nav-container">
            <div class="nav">
                <a href="${pageContext.request.contextPath}/appliances">电器设备</a>
                <a href="${pageContext.request.contextPath}/tasks">任务</a>
                <a href="${pageContext.request.contextPath}/home" class="active">用户</a>
                <a href="${pageContext.request.contextPath}/log">日志</a>
            </div>
            <a href="${pageContext.request.contextPath}/login" class="logout-btn">退出登录</a>
        </div>

    </div>

    <div class="container">
        <h2>用户列表</h2>
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="搜索用户名或邮箱...">
            <button onclick="searchUsers()">搜索</button>
            <button onclick="loadAllUsers()" style="background-color: #6c757d;">重置</button>
        </div>
        <p id="debugInfo" style="color: blue; font-size: 12px;"></p>
        <table id="userTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>邮箱</th>
                    <th>角色</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody id="userTableBody">
            </tbody>
        </table>
        <div id="emptyMessage" class="empty-message" style="display: none;">暂无用户</div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const API_BASE_URL = contextPath + '/api/users';

        function renderTable(users) {
            const debugInfo = document.getElementById('debugInfo');
            debugInfo.textContent = '已加载 ' + users.length + ' 个用户';

            const tbody = document.getElementById('userTableBody');
            const emptyMsg = document.getElementById('emptyMessage');

            tbody.innerHTML = '';

            if (users.length === 0) {
                emptyMsg.style.display = 'block';
                document.getElementById('userTable').style.display = 'none';
                return;
            } else {
                emptyMsg.style.display = 'none';
                document.getElementById('userTable').style.display = 'table';
            }

            users.forEach((user, index) => {
                const tr = document.createElement('tr');

                const userId = user.id || '-';
                const username = user.username || 'N/A';
                const email = user.email || 'N/A';
                const role = user.role || 'USER';
                const createdAt = user.createdAt ? new Date(user.createdAt).toLocaleString('zh-CN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit'
                }) : 'N/A';

                const roleBadge = role === 'ADMIN'
                    ? '<span class="role-badge role-admin">管理员</span>'
                    : '<span class="role-badge role-user">普通用户</span>';

                tr.innerHTML = '<td>' + userId + '</td>' +
                               '<td>' + username + '</td>' +
                               '<td>' + email + '</td>' +
                               '<td>' + roleBadge + '</td>' +
                               '<td>' + createdAt + '</td>' +
                               '<td>' +
                               '<button class="action-btn edit-btn" onclick="editUser(' + userId + ')">编辑</button>' +
                               '<button class="action-btn delete-btn" onclick="deleteUser(' + userId + ')">删除</button>' +
                               '</td>';
                tbody.appendChild(tr);
            });
        }

        function loadAllUsers() {
            document.getElementById('searchInput').value = '';
            fetch(API_BASE_URL, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.json())
            .then(users => {
                renderTable(users);
            })
            .catch(error => {
                console.error('Error fetching users:', error);
                alert('加载用户失败：' + error.message);
            });
        }

        window.searchUsers = function() {
            const keyword = document.getElementById('searchInput').value.trim();
            if (!keyword) {
                loadAllUsers();
                return;
            }

            fetch(API_BASE_URL + '/search?keyword=' + encodeURIComponent(keyword))
            .then(response => response.json())
            .then(users => {
                renderTable(users);
            })
            .catch(error => {
                console.error('Error searching users:', error);
                alert('搜索失败：' + error.message);
            });
        };

        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchUsers();
            }
        });

        window.deleteUser = function(id) {
            if (confirm('确定要删除这个用户吗？')) {
                fetch(API_BASE_URL + '/' + id, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        loadAllUsers();
                        alert('用户删除成功');
                    } else {
                        alert('删除失败');
                    }
                })
                .catch(error => {
                    console.error('Error deleting user:', error);
                    alert('删除用户出错：' + error.message);
                });
            }
        };

        window.editUser = function(id) {
            window.location.href = 'useredit?id=' + id;
        };

        loadAllUsers();
    </script>
</body>
</html>