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
        <h2>Register</h2>
        <form class="register-form" id="registerForm">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            <label for="confirm_password">Confirm Password:</label>
            <input type="password" id="confirm_password" name="confirm_password" required>
            <button type="submit">Register</button>
        </form>
        <div class="toggle-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm_password').value;

            // 1. 验证用户名：只能包含汉字、字母、数字
            const usernameRegex = /^[\u4e00-\u9fa5a-zA-Z0-9]+$/;
            if (!usernameRegex.test(username)) {
                alert('Username can only contain Chinese characters, letters, and numbers.');
                return;
            }

            // 2. 验证邮箱格式
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('Please enter a valid email address.');
                return;
            }

            // 3. 验证密码：必须同时包含字母和数字
            const hasLetter = /[a-zA-Z]/.test(password);
            const hasNumber = /[0-9]/.test(password);
            if (!hasLetter || !hasNumber) {
                alert('Password must contain both letters and numbers.');
                return;
            }

            // 4. 验证确认密码
            if (password !== confirmPassword) {
                alert('Passwords do not match.');
                return;
            }

            // 发送请求到后端 API
            fetch('${pageContext.request.contextPath}/api/users/register', {
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
                    alert('Registration successful!');
                    window.location.href = '${pageContext.request.contextPath}/login';
                } else if (response.status === 400) {
                    return response.text().then(text => {
                        throw new Error(text);
                    });
                } else {
                    throw new Error('Registration failed');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert(error.message || 'Registration failed. Please try again.');
            });
        });
    </script>
</body>
</html>