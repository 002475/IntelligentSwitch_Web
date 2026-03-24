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
            padding: 15px 0;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .header h1 {
            margin: 0;
            color: #333;
        }
        .header a {
            position: absolute;
            right: 20px;
            top: 20px;
            color: #007BFF;
            text-decoration: none;
            font-weight: bold;
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
        <h1>User Management</h1>
        <a href="${pageContext.request.contextPath}/login">Logout</a>
    </div>

    <div class="container">
        <h2>User List</h2>
        <table id="userTable">
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="userTableBody">
                <!-- User rows will be inserted here by JavaScript -->
            </tbody>
        </table>
        <div id="emptyMessage" class="empty-message" style="display: none;">No users found.</div>
    </div>

    <script>
        const STORAGE_KEY = 'intelligent_switch_users';
        const contextPath = '${pageContext.request.contextPath}';

        function initData() {
            if (!localStorage.getItem(STORAGE_KEY)) {
                const defaultUsers = [
                    { id: 1, username: 'admin', email: 'admin@example.com' },
                    { id: 2, username: 'user1', email: 'user1@example.com' },
                    { id: 3, username: 'test_user', email: 'test@example.com' }
                ];
                localStorage.setItem(STORAGE_KEY, JSON.stringify(defaultUsers));
            }
        }

        function getUsers() {
            const users = localStorage.getItem(STORAGE_KEY);
            return users ? JSON.parse(users) : [];
        }

        function saveUsers(users) {
            localStorage.setItem(STORAGE_KEY, JSON.stringify(users));
        }

        function renderTable() {
            const users = getUsers();
            const tbody = document.getElementById('userTableBody');
            const emptyMsg = document.getElementById('emptyMessage');
            
            tbody.innerHTML = '';

            if (users.length === 0) {
                emptyMsg.style.display = 'block';
                return;
            } else {
                emptyMsg.style.display = 'none';
            }

            users.forEach(user => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${user.username}</td>
                    <td>${user.email}</td>
                    <td>
                        <button class="action-btn edit-btn" onclick="editUser(${user.id})">Edit</button>
                        <button class="action-btn delete-btn" onclick="deleteUser(${user.id})">Delete</button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        }

        window.deleteUser = function(id) {
            if (confirm('Are you sure you want to delete this user?')) {
                let users = getUsers();
                users = users.filter(user => user.id !== id);
                saveUsers(users);
                renderTable();
            }
        };

        window.editUser = function(id) {
            window.location.href = `${contextPath}/useredit?id=${id}`;
        };

        initData();
        renderTable();
    </script>
</body>
</html>