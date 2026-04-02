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
        <a href="${pageContext.request.contextPath}/useredit" class="add-btn">添加用户</a>
        <p id="debugInfo" style="color: blue; font-size: 12px;"></p>
        <table id="userTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>邮箱</th>
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

        console.log('=== Debug Info ===');
        console.log('API Base URL:', API_BASE_URL);

        function renderTable() {
            const debugInfo = document.getElementById('debugInfo');
            debugInfo.textContent = 'Loading...';

            console.log('\n--- Fetching Users ---');
            console.log('Request URL:', API_BASE_URL);

            fetch(API_BASE_URL, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                console.log('Response Status:', response.status);
                console.log('Response OK:', response.ok);

                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(users => {
                console.log('Users data received:', users);
                console.log('Number of users:', users.length);

                debugInfo.textContent = 'Loaded ' + users.length + ' users successfully!';

                const tbody = document.getElementById('userTableBody');
                const emptyMsg = document.getElementById('emptyMessage');

                tbody.innerHTML = '';
                tbody.style.display = 'table-row-group';

                if (users.length === 0) {
                    emptyMsg.style.display = 'block';
                    document.getElementById('userTable').style.display = 'none';
                    console.log('No users in database');
                    return;
                } else {
                    emptyMsg.style.display = 'none';
                    document.getElementById('userTable').style.display = 'table';
                }

                users.forEach((user, index) => {
                    console.log(`Rendering user ${index + 1}:`, user);
                    const tr = document.createElement('tr');

                    const userId = user.id || '-';
                    const username = user.username || 'N/A';
                    const email = user.email || 'N/A';
                    const createdAt = user.createdAt ? new Date(user.createdAt).toLocaleString('zh-CN', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit'
                    }) : 'N/A';

                    tr.innerHTML = '<td>' + userId + '</td>' +
                                   '<td>' + username + '</td>' +
                                   '<td>' + email + '</td>' +
                                   '<td>' + createdAt + '</td>' +
                                   '<td>' +
                                   '<button class="action-btn edit-btn" onclick="editUser(' + userId + ')">编辑</button>' +
                                   '<button class="action-btn delete-btn" onclick="deleteUser(' + userId + ')">删除</button>' +
                                   '</td>';
                    tbody.appendChild(tr);
                });

                console.log('Table rendered successfully');
                console.log('Total rows in tbody:', tbody.children.length);
            })
            .catch(error => {
                console.error('=== ERROR ===');
                console.error('Error fetching users:', error);
                debugInfo.textContent = '错误：' + error.message;

                let errorMsg = '加载用户失败\n\n';
                errorMsg += '错误：' + error.message + '\n\n';
                errorMsg += '请检查后端是否运行在 http://localhost:8080';

                alert(errorMsg);
            });
        }

        window.deleteUser = function(id) {
            if (confirm('确定要删除这个用户吗？')) {
                const deleteUrl = API_BASE_URL + '/' + id;
                console.log('Deleting user with ID:', id);

                fetch(deleteUrl, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        renderTable();
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
            console.log('Editing user with ID:', id);
            window.location.href = 'useredit?id=' + id;
        };

        console.log('=== Page Loaded ===');
        renderTable();
    </script>
</body>
</html>