<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Electrical Appliances Management</title>
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
            position: relative;
        }
        .add-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }
        .add-btn:hover {
            background-color: #218838;
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
        <h1>电器设备管理</h1>
        <div class="nav-container">
            <div class="nav">
                <a href="${pageContext.request.contextPath}/appliances" class="active">电器设备</a>
                <a href="${pageContext.request.contextPath}/tasks">任务</a>
                <a href="${pageContext.request.contextPath}/home">用户</a>
                <a href="${pageContext.request.contextPath}/log">日志</a>
            </div>
            <a href="${pageContext.request.contextPath}/login" class="logout-btn">退出登录</a>
        </div>
    </div>

    <div class="container">
        <h2>电器设备列表</h2>
        <a href="${pageContext.request.contextPath}/applianceedit" class="add-btn">添加设备</a>
        <p id="debugInfo" style="color: blue; font-size: 12px;"></p>
        <table id="applianceTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>名称</th>
                    <th>位置</th>
                    <th>类型</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody id="applianceTableBody">
            </tbody>
        </table>
        <div id="emptyMessage" class="empty-message" style="display: none;">No appliances found.</div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const API_BASE_URL = contextPath + '/api/appliances';

        console.log('=== Debug Info ===');
        console.log('API Base URL:', API_BASE_URL);

        function renderTable() {
            const debugInfo = document.getElementById('debugInfo');
            debugInfo.textContent = 'Loading...';

            console.log('\n--- Fetching Appliances ---');
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
            .then(appliances => {
                console.log('Appliances data received:', appliances);
                console.log('Number of appliances:', appliances.length);

                debugInfo.textContent = 'Loaded ' + appliances.length + ' appliances successfully!';

                const tbody = document.getElementById('applianceTableBody');
                const emptyMsg = document.getElementById('emptyMessage');

                tbody.innerHTML = '';
                tbody.style.display = 'table-row-group';

                if (appliances.length === 0) {
                    emptyMsg.style.display = 'block';
                    document.getElementById('applianceTable').style.display = 'none';
                    console.log('No appliances in database');
                    return;
                } else {
                    emptyMsg.style.display = 'none';
                    document.getElementById('applianceTable').style.display = 'table';
                }

                appliances.forEach((appliance, index) => {
                    console.log(`Rendering appliance ${index + 1}:`, appliance);
                    const tr = document.createElement('tr');

                    const applianceId = appliance.id || '-';
                    const type = appliance.type || 'N/A';
                    const name = appliance.name || 'N/A';
                    const location = appliance.location || 'N/A';
                    const status = appliance.status !== null && appliance.status !== undefined ? appliance.status : false;

                    tr.innerHTML = '<td>' + applianceId + '</td>' +
                                   '<td>' + name + '</td>' +
                                   '<td>' + location + '</td>' +
                                   '<td>' + type + '</td>' +
                                   '<td><span class="status-badge ' + (status ? 'status-enabled' : 'status-disabled') + '">' + (status ? '开启' : '关闭') + '</span></td>' +
                                   '<td>' +
                                   '<button class="action-btn toggle-btn" onclick="toggleAppliance(' + applianceId + ', ' + status + ')">' + (status ? '关闭' : '开启') + '</button>' +
                                   '<button class="action-btn edit-btn" onclick="editAppliance(' + applianceId + ')">编辑</button>' +
                                   '<button class="action-btn delete-btn" onclick="deleteAppliance(' + applianceId + ')">删除</button>' +
                                   '</td>';
                    tbody.appendChild(tr);
                });

                console.log('Table rendered successfully');
                console.log('Total rows in tbody:', tbody.children.length);
            })
            .catch(error => {
                console.error('=== ERROR ===');
                console.error('Error fetching appliances:', error);
                debugInfo.textContent = 'Error: ' + error.message;

                let errorMsg = 'Failed to load appliances\n\n';
                errorMsg += 'Error: ' + error.message + '\n\n';
                errorMsg += 'Please check backend is running on http://localhost:8080';

                alert(errorMsg);
            });
        }

        window.deleteAppliance = function(id) {
            if (confirm('确定要删除这个设备吗？')) {
                const deleteUrl = API_BASE_URL + '/' + id;
                console.log('Deleting appliance with ID:', id);

                fetch(deleteUrl, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        renderTable();
                        alert('设备删除成功');
                    } else {
                        alert('删除失败');
                    }
                })
                .catch(error => {
                    console.error('Error deleting appliance:', error);
                    alert('Error deleting appliance: ' + error.message);
                });
            }
        };

        window.toggleAppliance = function(id, currentStatus) {
            const toggleUrl = API_BASE_URL + '/' + id + '/toggle-status';
            console.log('Toggling status for appliance ID:', id, 'Current:', currentStatus);

            fetch(toggleUrl, {
                method: 'PATCH'
            })
                .then(response => {
                    if (response.ok) {
                        renderTable();
                        alert('设备状态已切换');
                    } else {
                        alert('切换失败');
                    }
                })
                .catch(error => {
                    console.error('Error toggling status:', error);
                    alert('Error: ' + error.message);
                });
        };

        window.editAppliance = function(id) {
            console.log('Editing appliance with ID:', id);
            window.location.href = contextPath + '/applianceedit?id=' + id;
        };

        console.log('=== Page Loaded ===');
        renderTable();
    </script>
</body>
</html>
