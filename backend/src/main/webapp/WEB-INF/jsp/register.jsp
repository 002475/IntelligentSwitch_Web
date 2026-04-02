<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Page</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-image: url("${pageContext.request.contextPath}/images/login_register_bg.png"); /* 确保图片在同一目录 */
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .register-container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        .register-form {
            display: flex;
            flex-direction: column;
        }
        .register-form label {
            margin-bottom: 5px;
        }
        .register-form input {
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .register-form button {
            padding: 10px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .register-form button:hover {
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
    <div class="register-container">
        <h2>注册</h2>
        <form class="register-form" id="registerForm">
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username" required>
            <label for="email">邮箱:</label>
            <input type="email" id="email" name="email" required>
            <label for="password">密码:</label>
            <input type="password" id="password" name="password" required>
            <label for="confirm_password">确认密码:</label>
            <input type="password" id="confirm_password" name="confirm_password" required>
            <button type="submit">注册</button>
        </form>
        <div class="toggle-link">
            已有账号？<a href="${pageContext.request.contextPath}/login">立即登录</a>
        </div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const formData = {
                username: document.getElementById('username').value.trim(),
                password: document.getElementById('password').value,
                confirmPassword: document.getElementById('confirmPassword').value
            };

            // 1. 验证用户名：只能包含汉字、字母、数字
            const usernameRegex = /^[\u4e00-\u9fa5a-zA-Z0-9]+$/;
            if (!usernameRegex.test(formData.username)) {
                alert('用户名只能包含汉字、字母和数字。');
                return;
            }

            // 2. 验证密码：必须同时包含字母和数字
            const hasLetter = /[a-zA-Z]/.test(formData.password);
            const hasNumber = /[0-9]/.test(formData.password);
            if (!hasLetter || !hasNumber) {
                alert('密码必须同时包含字母和数字。');
                return;
            }

            // 3. 验证确认密码
            if (formData.password !== formData.confirmPassword) {
                alert('两次输入的密码不一致！');
                return;
            }

            const contextPath = '${pageContext.request.contextPath}';
            fetch(contextPath + '/api/users/register', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    username: formData.username,
                    password: formData.password
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('注册成功！即将跳转到登录页面...');
                    setTimeout(() => {
                        window.location.href = contextPath + '/login';
                    }, 1500);
                } else {
                    alert('注册失败：' + (data.message || '未知错误'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('注册失败，请稍后再试。');
            });
        });
    </script>
</body>
</html>