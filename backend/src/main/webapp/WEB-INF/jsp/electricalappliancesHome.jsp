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
        <h1>Electrical Appliances Management</h1>
        <div class="nav-container">
            <div class="nav">
                <a href="${pageContext.request.contextPath}/appliances" class="active">Electrical Appliances</a>
                <a href="${pageContext.request.contextPath}/home">Users</a>
                <a href="${pageContext.request.contextPath}/log">Log</a>
            </div>
            <a href="${pageContext.request.contextPath}/login" class="logout-btn">Logout</a>
        </div>
    </div>

    <div class="container">
        <h2>Electrical Appliances</h2>
        <a href="${pageContext.request.contextPath}/applianceedit" class="add-btn">Add</a>
        <p id="debugInfo" style="color: blue; font-size: 12px;"></p>
        <table id="applianceTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Type</th>
                    <th>Name</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th>Actions</th>
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
                                   '<td>' + type + '</td>' +
                                   '<td>' + name + '</td>' +
                                   '<td>' + location + '</td>' +
                                   '<td>' +
                                   '<button class="action-btn ' + (status ? 'edit-btn' : 'delete-btn') + '" onclick="toggleStatus(' + applianceId + ', ' + status + ')">' + (status ? 'ON' : 'OFF') + '</button>' +
                                   '</td>' +
                                   '<td>' +
                                   '<button class="action-btn edit-btn" onclick="editAppliance(' + applianceId + ')">Edit</button>' +
                                   '<button class="action-btn delete-btn" onclick="deleteAppliance(' + applianceId + ')">Delete</button>' +
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
            if (confirm('Are you sure you want to delete this appliance?')) {
                const deleteUrl = API_BASE_URL + '/' + id;
                console.log('Deleting appliance with ID:', id);

                fetch(deleteUrl, {
                    method: 'DELETE'
                })
                .then(response => {
                    console.log('Delete response status:', response.status);
                    if (response.ok) {
                        renderTable();
                        alert('Appliance deleted successfully');
                    } else if (response.status === 404) {
                        alert('Appliance not found.');
                        renderTable();
                    } else {
                        alert('Failed to delete appliance');
                    }
                })
                .catch(error => {
                    console.error('Error deleting appliance:', error);
                    alert('Error deleting appliance: ' + error.message);
                });
            }
        };

        window.toggleStatus = function(id, currentStatus) {
            const toggleUrl = API_BASE_URL + '/' + id + '/toggle-status';
            console.log('Toggling status for appliance ID:', id, 'Current:', currentStatus);

            fetch(toggleUrl, {
                method: 'PATCH'
            })
            .then(response => {
                console.log('Toggle status response:', response.status);
                if (response.ok) {
                    renderTable();
                    const newStatus = !currentStatus;
                    alert('Appliance turned ' + (newStatus ? 'ON' : 'OFF'));
                } else {
                    alert('Failed to toggle status');
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
