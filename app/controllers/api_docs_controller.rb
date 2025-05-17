class ApiDocsController < ApplicationController
  def index
    render html: <<-HTML.html_safe
<!DOCTYPE html>
<html>
<head>
  <title>Hindsite API Documentation</title>
  <link rel="icon" href="/icon.png" type="image/png">
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    .nav-logo {
      max-height: 50px;
      margin-right: 15px;
      vertical-align: middle;
    }
    .header {
      display: flex;
      align-items: center;
      margin-bottom: 30px;
      border-bottom: 1px solid #eee;
      padding-bottom: 15px;
    }
    .endpoint {
      background-color: #f8f9fa;
      border-radius: 4px;
      padding: 20px;
      margin-bottom: 20px;
      border-left: 4px solid #3498db;
    }
    .method {
      display: inline-block;
      padding: 4px 8px;
      border-radius: 4px;
      font-weight: bold;
      margin-right: 10px;
    }
    .get { background-color: #61affe; color: white; }
    .post { background-color: #49cc90; color: white; }
    .put { background-color: #fca130; color: white; }
    .delete { background-color: #f93e3e; color: white; }
    .patch { background-color: #50e3c2; color: white; }
    
    .path {
      font-family: monospace;
      font-size: 1.1em;
      font-weight: bold;
    }
    .section {
      margin-top: 30px;
      border-bottom: 1px solid #eee;
      padding-bottom: 10px;
    }
    .response {
      background-color: #272822;
      color: #f8f8f2;
      padding: 15px;
      border-radius: 4px;
      overflow-x: auto;
      font-family: monospace;
    }
    .deprecated {
      text-decoration: line-through;
      opacity: 0.7;
    }
    .new {
      background-color: #8bc34a;
      color: white;
      font-size: 0.8em;
      padding: 2px 5px;
      border-radius: 4px;
      margin-left: 5px;
      vertical-align: middle;
    }
    .try-it {
      background-color: #3498db;
      color: white;
      border: none;
      padding: 8px 15px;
      border-radius: 4px;
      cursor: pointer;
      float: right;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 15px 0;
    }
    th, td {
      text-align: left;
      padding: 8px;
      border-bottom: 1px solid #ddd;
    }
    th {
      background-color: #f2f2f2;
    }
  </style>
</head>
<body>
  <div class="header">
    <img src="/HINDSITE-NAV.svg" alt="Hindsite Logo" class="nav-logo">
    <h1>Hindsite API Documentation</h1>
  </div>
  
  <p>This documentation describes the Hindsite API endpoints and how to use them.</p>
  
  <!-- API Version Info -->
  <div class="section">
    <h2>API Information</h2>
    <p><strong>Version:</strong> 1.0</p>
    <p><strong>Base URL:</strong> <code>/api/v1</code></p>
    <p><strong>Update Note:</strong> The API now supports multi-organization functionality. Users can belong to multiple organizations, with one designated as their primary organization.</p>
  </div>

  <!-- Authentication Section -->
  <div class="section">
    <h2>Authentication</h2>
    <p>All API requests require authentication using an API key or session token.</p>
  </div>
  
  <!-- Users Endpoints -->
  <div class="section">
    <h2>Users</h2>
    
    <!-- List Users -->
    <div class="endpoint">
      <span class="method get">GET</span>
      <span class="path">/api/v1/users</span>
      <button class="try-it" onclick="tryEndpoint('get', '/api/v1/users')">Try it</button>
      <h3>List Active Users</h3>
      <p>Returns a list of all active users in the system.</p>
      
      <h4>Response</h4>
      <pre class="response">[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "organisation_id": 2,  // Deprecated, kept for backward compatibility
    "organisation_name": "Acme Corp",  // Deprecated, kept for backward compatibility
    "organisations": [  // New field with multi-org support
      {
        "id": 2,
        "name": "Acme Corp",
        "is_primary": true
      },
      {
        "id": 3,
        "name": "Tech Innovators",
        "is_primary": false
      }
    ],
    "primary_organisation": {  // New field showing primary organization
      "id": 2,
      "name": "Acme Corp"
    }
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "email": "jane@example.com",
    "organisation_id": 1,
    "organisation_name": "Global Solutions",
    "organisations": [
      {
        "id": 1,
        "name": "Global Solutions",
        "is_primary": true
      }
    ],
    "primary_organisation": {
      "id": 1,
      "name": "Global Solutions"
    }
  }
]</pre>
    </div>
    
    <!-- Get User -->
    <div class="endpoint">
      <span class="method get">GET</span>
      <span class="path">/api/v1/users/{id}</span>
      <button class="try-it" onclick="tryEndpoint('get', '/api/v1/users/1')">Try it</button>
      <h3>Get User</h3>
      <p>Returns details for a specific user.</p>
      
      <h4>Parameters</h4>
      <table>
        <tr>
          <th>Name</th>
          <th>Type</th>
          <th>In</th>
          <th>Required</th>
          <th>Description</th>
        </tr>
        <tr>
          <td>id</td>
          <td>integer</td>
          <td>path</td>
          <td>Yes</td>
          <td>The user ID</td>
        </tr>
      </table>
      
      <h4>Response</h4>
      <pre class="response">{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "organisation_id": 2,  // Deprecated, kept for backward compatibility
  "organisation_name": "Acme Corp",  // Deprecated, kept for backward compatibility
  "organisations": [  // New field with multi-org support
    {
      "id": 2,
      "name": "Acme Corp",
      "is_primary": true
    },
    {
      "id": 3,
      "name": "Tech Innovators",
      "is_primary": false
    }
  ],
  "primary_organisation": {  // New field showing primary organization
    "id": 2,
    "name": "Acme Corp"
  }
}</pre>

      <h4>Error Responses</h4>
      <pre class="response">// 404 Not Found
{
  "error": "User not found"
}</pre>
    </div>

    <!-- Get User's Organizations -->
    <div class="endpoint">
      <span class="method get">GET</span>
      <span class="path">/api/v1/users/{id}/organisations</span>
      <span class="new">NEW</span>
      <button class="try-it" onclick="tryEndpoint('get', '/api/v1/users/1/organisations')">Try it</button>
      <h3>Get User's Organizations</h3>
      <p>Returns all organizations a user belongs to.</p>
      
      <h4>Parameters</h4>
      <table>
        <tr>
          <th>Name</th>
          <th>Type</th>
          <th>In</th>
          <th>Required</th>
          <th>Description</th>
        </tr>
        <tr>
          <td>id</td>
          <td>integer</td>
          <td>path</td>
          <td>Yes</td>
          <td>The user ID</td>
        </tr>
      </table>
      
      <h4>Response</h4>
      <pre class="response">{
  "organisations": [
    {
      "id": 2,
      "name": "Acme Corp",
      "country": "United States",
      "language": "English",
      "is_primary": true
    },
    {
      "id": 3,
      "name": "Tech Innovators",
      "country": "Canada",
      "language": "English",
      "is_primary": false
    }
  ],
  "primary_organisation_id": 2
}</pre>
    </div>
  </div>

  <!-- JavaScript for the "Try it" functionality -->
  <script>
    function tryEndpoint(method, path) {
      const resultElement = document.createElement('div');
      resultElement.innerHTML = `<p>Sending ${method.toUpperCase()} request to ${path}...</p>`;
      
      // Add the result element after the button that was clicked
      event.target.parentNode.appendChild(resultElement);
      
      fetch(path, {
        method: method.toUpperCase(),
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        resultElement.innerHTML = `<p>Response:</p><pre class="response">${JSON.stringify(data, null, 2)}</pre>`;
      })
      .catch(error => {
        resultElement.innerHTML = `<p>Error: ${error.message}</p>`;
      });
    }
  </script>
</body>
</html>
    HTML
  end
end 