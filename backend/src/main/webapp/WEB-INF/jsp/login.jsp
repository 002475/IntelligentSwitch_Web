<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
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
        .login-container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        .login-form {
            display: flex;
            flex-direction: column;
        }
        .login-form label {
            margin-bottom: 5px;
        }
        .login-form input {
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .login-form button {
            padding: 10px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .login-form button:hover {
            background-color: #0056b3;
        }
        .toggle-link {
            margin-top: 15px;
            text-align: center;
            font-size: 14px;
        }
        .toggle-link a {
            color: #007BFF;
            text-decoration: none;
        }
        .toggle-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>登录</h2>
        <form class="login-form" id="loginForm">
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username" required>
            <label for="password">密码:</label>
            <input type="password" id="password" name="password" required>
            <button type="submit">登录</button>
        </form>
        <div class="toggle-link">
            还没有账号？<a href="${pageContext.request.contextPath}/register">立即注册</a>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!username || !password) {
                alert('请输入用户名和密码。');
                return;
            }

            fetch('${pageContext.request.contextPath}/api/users')
                .then(response => response.json())
                .then(users => {
                    const user = users.find(u => u.username === username && u.password === password);

                    if (user) {
                        sessionStorage.setItem('currentUser', JSON.stringify(user));
                        window.location.href = '${pageContext.request.contextPath}/home';
                    } else {
                        const userByName = users.find(u => u.username === username);
                        if (userByName) {
                            alert('密码错误。');
                        } else {
                            alert('账号不存在，请先注册。');
                        }
                    }
                })
                .catch(error => {
                    console.error('Login error:', error);
                    alert('登录失败：' + error.message);
                });
        });
    </script>
</body>
</html>