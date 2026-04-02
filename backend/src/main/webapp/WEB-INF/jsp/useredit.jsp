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
        <h2 id="pageHeader">添加用户</h2>
        <form class="edit-form" id="editForm">
            <input type="hidden" id="userId">

            <label for="username">用户名：</label>
            <input type="text" id="username" name="username" required>

            <label for="email">邮箱：</label>
            <input type="email" id="email" name="email" required>

            <label for="password">密码：</label>
            <input type="password" id="password" name="password" required>

            <div class="btn-group">
                <button type="button" class="cancel-btn" onclick="window.location.href='${pageContext.request.contextPath}/home'">取消</button>
                <button type="submit" class="save-btn">保存</button>
            </div>
        </form>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const API_BASE_URL = contextPath + '/api/users';

        console.log('Edit Page Debug:');
        console.log('Context Path:', contextPath);
        console.log('API Base URL:', API_BASE_URL);
        console.log('Current URL:', window.location.href);

        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const userId = urlParams.get('id');

            console.log('User ID from URL:', userId);

            if (userId) {
                isEditMode = true;
                document.getElementById('pageHeader').textContent = '编辑用户';

                const fetchUrl = API_BASE_URL + '/' + userId;
                console.log('Fetching user from:', fetchUrl);

                fetch(fetchUrl)
                    .then(response => {
                        console.log('Response status:', response.status);
                        if (!response.ok) {
                            throw new Error('用户不存在');
                        }
                        return response.json();
                    })
                    .then(user => {
                        console.log('User data loaded:', user);
                        document.getElementById('userId').value = user.id;
                        document.getElementById('username').value = user.username;
                        document.getElementById('email').value = user.email;
                    })
                    .catch(error => {
                        console.error('Error fetching user:', error);
                        alert('用户不存在。错误：' + error.message);
                        window.location.href = contextPath + '/home';
                    });
            } else {
                isEditMode = false;
                document.getElementById('pageHeader').textContent = '添加用户';
            }
        });

        document.getElementById('editForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const userId = document.getElementById('userId').value;
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!username || !email || !password) {
                alert('请填写完整信息。');
                return;
            }

            const usernameRegex = /^[\u4e00-\u9fa5a-zA-Z0-9]+$/;
            if (!usernameRegex.test(username)) {
                alert('用户名只能包含中文字符、字母和数字。');
                return;
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('请输入有效的邮箱地址。');
                return;
            }

            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
            if (!passwordRegex.test(password)) {
                alert('密码必须包含至少一个小写字母、一个大写字母和一个数字，并且长度至少为 8 位。');
                return;
            }

            if (userId) {
                const updateUrl = API_BASE_URL + '/' + userId;
                console.log('Updating user at:', updateUrl);

                fetch(updateUrl, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        username: username,
                        email: email,
                        password: password
                    })
                })
                .then(response => {
                    if (response.ok) {
                        alert('用户更新成功！');
                        window.location.href = contextPath + '/home';
                    } else {
                        alert('更新失败，请重试。');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('更新失败，请重试。');
                });
            } else {
                const createUrl = API_BASE_URL;
                console.log('Creating user at:', createUrl);

                fetch(createUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        username: username,
                        email: email,
                        password: password
                    })
                })
                .then(response => {
                    if (response.ok) {
                        alert('用户添加成功！');
                        window.location.href = contextPath + '/home';
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