<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
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
            height: 100vh;
        }
        .edit-container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        .edit-form {
            display: flex;
            flex-direction: column;
        }
        .edit-form label {
            margin-bottom: 5px;
        }
        .edit-form input {
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
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
    </style>
</head>
<body>
    <div class="edit-container">
        <h2>Edit User</h2>
        <form class="edit-form" id="editForm">
            <input type="hidden" id="userId">
            <label for="username">Username:</label>
            <input type="text" id="username" required>
            <label for="email">Email:</label>
            <input type="email" id="email" required>
            
            <div class="btn-group">
                <button type="button" class="cancel-btn" onclick="window.location.href='${pageContext.request.contextPath}/home'">Cancel</button>
                <button type="submit" class="save-btn">Save Changes</button>
            </div>
        </form>
    </div>

    <script>
        const STORAGE_KEY = 'intelligent_switch_users';
        const contextPath = '${pageContext.request.contextPath}';

        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const userId = urlParams.get('id');

            if (!userId) {
                alert('Invalid user ID.');
                window.location.href = `${contextPath}/home`;
                return;
            }

            const users = JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
            const user = users.find(u => u.id == userId);

            if (!user) {
                alert('User not found.');
                window.location.href = `${contextPath}/home`;
                return;
            }

            document.getElementById('userId').value = user.id;
            document.getElementById('username').value = user.username;
            document.getElementById('email').value = user.email;
        });

        document.getElementById('editForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const userId = document.getElementById('userId').value;
            const newUsername = document.getElementById('username').value.trim();
            const newEmail = document.getElementById('email').value.trim();

            if (!newUsername || !newEmail) {
                alert('Username and Email cannot be empty.');
                return;
            }

            const usernameRegex = /^[\u4e00-\u9fa5a-zA-Z0-9]+$/;
            if (!usernameRegex.test(newUsername)) {
                alert('Username can only contain Chinese characters, letters, and numbers.');
                return;
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(newEmail)) {
                alert('Please enter a valid email address.');
                return;
            }

            let users = JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
            const userIndex = users.findIndex(u => u.id == userId);

            if (userIndex !== -1) {
                const isDuplicate = users.some((u, index) => u.username === newUsername && index !== userIndex);
                if (isDuplicate) {
                    alert('Username already exists.');
                    return;
                }

                users[userIndex].username = newUsername;
                users[userIndex].email = newEmail;
                
                localStorage.setItem(STORAGE_KEY, JSON.stringify(users));
                alert('User updated successfully!');
                window.location.href = `${contextPath}/home`;
            } else {
                alert('Error: User not found.');
            }
        });
    </script>
</body>
</html>