class ApiDocsController < ApplicationController
  def index
    render html: '<h1>Hindsite API Documentation</h1>
                 <h2>API Endpoints</h2>
                 <ul>
                   <li><a href="/api/v1/users">/api/v1/users</a> - List all active users</li>
                   <li><a href="/api/v1/users/1">/api/v1/users/:id</a> - Get a specific user by ID</li>
                 </ul>
                 <h2>User Response Format</h2>
                 <pre>
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "organisation_id": 1,
  "organisation_name": "ACME Corp"
}
                 </pre>'.html_safe
  end
end 