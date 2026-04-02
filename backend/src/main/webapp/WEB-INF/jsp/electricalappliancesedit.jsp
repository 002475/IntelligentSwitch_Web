<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Electrical Appliance</title>
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
            width: 350px;
        }
        .edit-form {
            display: flex;
            flex-direction: column;
        }
        .edit-form label {
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .edit-form input, .edit-form select {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        .edit-form input:focus, .edit-form select:focus {
            outline: none;
            border-color: #007BFF;
        }
        .edit-form select {
            color: #666;
        }
        .edit-form select:valid {
            color: #333;
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
            font-weight: bold;
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
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }
        .form-title {
            font-size: 18px;
            margin-bottom: 10px;
            color: #007BFF;
        }
    </style>
</head>
<body>
    <div class="edit-container">
        <h2 id="pageHeader">添加设备</h2>
        <form class="edit-form" id="editForm">
            <input type="hidden" id="applianceId">

            <label for="name">设备名称：</label>
            <input type="text" id="name" name="name" required>

            <label for="location">位置：</label>
            <input type="text" id="location" name="location" required>

            <label for="type">类型：</label>
            <select id="type" name="type" required>
                <option value="">请选择类型</option>
                <option value="LIGHT">灯</option>
                <option value="AIR_CONDITIONER">空调</option>
                <option value="TV">电视</option>
                <option value="FAN">风扇</option>
                <option value="OTHER">其他</option>
            </select>

            <div class="checkbox-group">
                <input type="checkbox" id="statusCheckbox">
                <label for="statusCheckbox">开启</label>
            </div>

            <div class="btn-group">
                <button type="button" class="cancel-btn" onclick="window.location.href='${pageContext.request.contextPath}/appliances'">取消</button>
                <button type="submit" class="save-btn">保存</button>
            </div>
        </form>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const API_BASE_URL = contextPath + '/api/appliances';
        let isEditMode = false;

        console.log('Edit Page Debug:');
        console.log('Context Path:', contextPath);
        console.log('API Base URL:', API_BASE_URL);
        console.log('Current URL:', window.location.href);

        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const applianceId = urlParams.get('id');

            console.log('Appliance ID from URL:', applianceId);

            if (applianceId) {
                isEditMode = true;
                document.getElementById('pageHeader').textContent = '编辑设备';
                loadAppliance(applianceId);
            } else {
                isEditMode = false;
                document.getElementById('pageHeader').textContent = '添加设备';
            }
        });

        function loadAppliance(applianceId) {
            const fetchUrl = API_BASE_URL + '/' + applianceId;
            console.log('Fetching appliance from:', fetchUrl);

            fetch(fetchUrl)
                .then(response => {
                    console.log('Response status:', response.status);
                    if (!response.ok) {
                        throw new Error('Appliance not found');
                    }
                    return response.json();
                })
                .then(appliance => {
                    console.log('Appliance data loaded:', appliance);
                    document.getElementById('applianceId').value = appliance.id;
                    document.getElementById('name').value = appliance.name;
                    document.getElementById('location').value = appliance.location;
                    document.getElementById('type').value = appliance.type;
                    document.getElementById('statusCheckbox').checked = appliance.status;
                })
                .catch(error => {
                    console.error('Error fetching appliance:', error);
                    alert('设备不存在。错误：' + error.message);
                    window.location.href = contextPath + '/appliances';
                });

        }

        document.getElementById('editForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const applianceId = document.getElementById('applianceId').value;
            const name = document.getElementById('name').value.trim();
            const location = document.getElementById('location').value.trim();
            const type = document.getElementById('type').value;
            const status = document.getElementById('statusCheckbox').checked;

            if (!name || !location || !type) {
                alert('请填写完整信息。');
                return;
            }

            if (isEditMode && applianceId) {
                const updateUrl = API_BASE_URL + '/' + applianceId;
                console.log('Updating appliance at:', updateUrl);

                fetch(updateUrl, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        name: name,
                        location: location,
                        type: type,
                        status: status
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.timestamp && data.status === 500) {
                        alert('电器名称重复');
                    } else if (typeof data === 'string') {
                        if (data.includes('已存在')) {
                            alert('电器名称重复');
                        } else {
                            alert(data);
                        }
                    } else if (data.name) {
                        alert('设备更新成功！');
                        window.location.href = contextPath + '/appliances';
                    } else {
                        alert('更新失败，请重试。');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('更新失败：' + error.message);
                });

            } else {
                console.log('Creating new appliance');

                fetch(API_BASE_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        name: name,
                        location: location,
                        type: type,
                        status: status
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.timestamp && data.status === 500) {
                        alert('电器名称重复');
                    } else if (typeof data === 'string') {
                        if (data.includes('已存在')) {
                            alert('电器名称重复');
                        } else {
                            alert(data);
                        }
                    } else if (data.name) {
                        alert('设备添加成功！');
                        window.location.href = contextPath + '/appliances';
                    } else {
                        alert('添加失败，请重试。');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('操作失败：' + error.message);
                });

            }
        });
    </script>
</body>
</html>
