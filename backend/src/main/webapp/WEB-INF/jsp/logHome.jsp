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
        <h1>Log Management</h1>
        <div class="nav-container">
            <div class="nav">
                <a href="${pageContext.request.contextPath}/appliances">Electrical Appliances</a>
                <a href="${pageContext.request.contextPath}/tasks">Tasks</a>
                <a href="${pageContext.request.contextPath}/home">Users</a>
                <a href="${pageContext.request.contextPath}/log" class="active">Log</a>
            </div>
            <a href="${pageContext.request.contextPath}/login" class="logout-btn">Logout</a>
        </div>

    </div>


</body>
</html>

