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
        <h1>User Management</h1>
        <div class="nav-container">
            <div class="nav">
                <a href="${pageContext.request.contextPath}/appliances">Electrical Appliances</a>
                <a href="${pageContext.request.contextPath}/tasks">Tasks</a>
                <a href="${pageContext.request.contextPath}/home" class="active">Users</a>
                <a href="${pageContext.request.contextPath}/log">Log</a>
            </div>
            <a href="${pageContext.request.contextPath}/login" class="logout-btn">Logout</a>
        </div>

    </div>

    <div class="container">
        <h2>User List</h2>
        <p id="debugInfo" style="color: blue; font-size: 12px;"></p>
        <table id="userTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="userTableBody">
            </tbody>
        </table>
        <div id="emptyMessage" class="empty-message" style="display: none;">No users found.</div>
    </div>

    <script>
        const API_BASE_URL = 'http://localhost:8080/api/users';

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

                    tr.innerHTML = '<td>' + userId + '</td>' +
                                   '<td>' + username + '</td>' +
                                   '<td>' + email + '</td>' +
                                   '<td>' +
                                   '<button class="action-btn edit-btn" onclick="editUser(' + userId + ')">Edit</button>' +
                                   '<button class="action-btn delete-btn" onclick="deleteUser(' + userId + ')">Delete</button>' +
                                   '</td>';
                    tbody.appendChild(tr);
                });

                console.log('Table rendered successfully');
                console.log('Total rows in tbody:', tbody.children.length);
            })
            .catch(error => {
                console.error('=== ERROR ===');
                console.error('Error fetching users:', error);
                debugInfo.textContent = 'Error: ' + error.message;

                let errorMsg = 'Failed to load users\n\n';
                errorMsg += 'Error: ' + error.message + '\n\n';
                errorMsg += 'Please check backend is running on http://localhost:8080';

                alert(errorMsg);
            });
        }

        window.deleteUser = function(id) {
            if (confirm('Are you sure you want to delete this user?')) {
                const deleteUrl = API_BASE_URL + '/' + id;
                console.log('Deleting user with ID:', id);

                fetch(deleteUrl, {
                    method: 'DELETE'
                })
                .then(response => {
                    console.log('Delete response status:', response.status);
                    if (response.ok) {
                        renderTable();
                        alert('User deleted successfully');
                    } else if (response.status === 404) {
                        alert('User not found.');
                        renderTable();
                    } else {
                        alert('Failed to delete user');
                    }
                })
                .catch(error => {
                    console.error('Error deleting user:', error);
                    alert('Error deleting user: ' + error.message);
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