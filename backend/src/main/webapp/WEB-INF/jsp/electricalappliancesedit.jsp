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
        <h2 id="pageHeader">Add Electrical Appliance</h2>
        <div class="form-title" id="formTitle" style="display: none;"></div>
        <form class="edit-form" id="editForm">
            <input type="hidden" id="applianceId">

            <label for="type">Type:</label>
            <select id="type" required>
                <option value="" disabled selected>Select Type</option>
                <option value="Lighting">Lighting</option>
                <option value="HVAC">HVAC (Heating/Cooling)</option>
                <option value="Kitchen">Kitchen Appliance</option>
                <option value="Entertainment">Entertainment</option>
                <option value="Security">Security Device</option>
                <option value="Washer">Washer/Dryer</option>
                <option value="Other">Other</option>
            </select>

            <label for="name">Name:</label>
            <input type="text" id="name" placeholder="e.g., Living Room Light" required>

            <label for="location">Location:</label>
            <input type="text" id="location" placeholder="e.g., Living Room, Floor 1" required>

            <label for="status">Status:</label>
            <select id="status" required>
                <option value="true">ON</option>
                <option value="false">OFF</option>
            </select>

            <div class="btn-group">
                <button type="button" class="cancel-btn" onclick="window.location.href='${pageContext.request.contextPath}/appliances'">Cancel</button>
                <button type="submit" class="save-btn">Save</button>
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
                document.getElementById('pageHeader').textContent = 'Edit Electrical Appliance';

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
                        document.getElementById('type').value = appliance.type;
                        document.getElementById('name').value = appliance.name;
                        document.getElementById('location').value = appliance.location;
                        document.getElementById('status').value = appliance.status.toString();
                    })
                    .catch(error => {
                        console.error('Error fetching appliance:', error);
                        alert('Appliance not found. Error: ' + error.message);
                        window.location.href = contextPath + '/appliances';
                    });
            } else {
                isEditMode = false;
                document.getElementById('pageHeader').textContent = 'Add Electrical Appliance';
                document.getElementById('applianceId').value = '';
            }
        });

        document.getElementById('editForm').addEventListener('submit', function(event) {
            event.preventDefault();

            const applianceId = document.getElementById('applianceId').value;
            const newType = document.getElementById('type').value.trim();
            const newName = document.getElementById('name').value.trim();
            const newLocation = document.getElementById('location').value.trim();
            const newStatus = document.getElementById('status').value === 'true';

            if (!newType || !newName || !newLocation) {
                alert('Type, Name, and Location cannot be empty.');
                return;
            }

            if (newName.length < 2 || newName.length > 100) {
                alert('Name must be between 2 and 100 characters.');
                return;
            }

            if (newLocation.length < 2 || newLocation.length > 200) {
                alert('Location must be between 2 and 200 characters.');
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
                        type: newType,
                        name: newName,
                        location: newLocation,
                        status: newStatus
                    })
                })
                .then(response => {
                    console.log('Update response status:', response.status);
                    if (response.ok) {
                        alert('Appliance updated successfully!');
                        window.location.href = contextPath + '/appliances';
                    } else if (response.status === 404) {
                        alert('Appliance not found.');
                    } else {
                        alert('Update failed. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Update failed. Please try again.');
                });
            } else {
                console.log('Creating new appliance');

                fetch(API_BASE_URL, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        type: newType,
                        name: newName,
                        location: newLocation,
                        status: newStatus
                    })
                })
                .then(response => {
                    console.log('Create response status:', response.status);
                    if (response.ok) {
                        alert('Appliance added successfully!');
                        window.location.href = contextPath + '/appliances';
                    } else {
                        alert('Failed to add appliance. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to add appliance. Please try again.');
                });
            }
        });
    </script>
</body>
</html>
