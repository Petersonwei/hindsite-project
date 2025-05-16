require 'swagger_helper'

RSpec.describe 'API V1 Users', type: :request do
  path '/api/v1/users' do
    get 'Retrieves all active users' do
      tags 'Users'
      produces 'application/json'
      
      response '200', 'users found' do
        schema type: :array,
               items: { '$ref' => '#/components/schemas/User' }
        
        run_test!
      end
    end
  end
  
  path '/api/v1/users/{id}' do
    get 'Retrieves a specific user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'
      
      response '200', 'user found' do
        schema '$ref' => '#/components/schemas/User'
        
        let(:id) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password', status: 'active').id }
        run_test!
      end
      
      response '404', 'user not found' do
        schema '$ref' => '#/components/schemas/Error'
        
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end 