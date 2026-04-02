<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log Management</title>
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
        .content-message {
            text-align: center;
            color: #666;
            padding: 40px 20px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>系统日志</h1>
        <div class="nav-container">
            <div class="nav">
                <a href="${pageContext.request.contextPath}/appliances">电器设备</a>
                <a href="${pageContext.request.contextPath}/tasks">任务</a>
                <a href="${pageContext.request.contextPath}/home">用户</a>
                <a href="${pageContext.request.contextPath}/log" class="active">日志</a>
            </div>
            <a href="${pageContext.request.contextPath}/login" class="logout-btn">退出登录</a>
        </div>

    </div>
    <div class="container">
        <h2>日志列表</h2>
        <table>
            <thead>
                <tr>
                    <th>时间</th>
                    <th>级别</th>
                    <th>消息</th>

                </tr>
            </thead>
            <tbody>
                <c:forEach var="log" items="${logs}">
                    <tr>
                        <td>${log.timestamp}</td>
                        <td>${log.level}</td>
                        <td>${log.message}</td>

                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</body>
</html>

