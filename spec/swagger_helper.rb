# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Hindsite API Documentation',
        version: 'v1',
        description: 'Hindsite is a knowledge sharing platform that allows employees to post and retrieve information within organizations.',
        contact: {
          name: 'API Support',
          email: 'support@example.com'
        },
        license: {
          name: 'MIT',
          url: 'https://opensource.org/licenses/MIT'
        }
      },
      paths: {},
      components: {
        schemas: {
          User: {
            type: 'object',
            properties: {
              id: { type: 'integer', example: 1 },
              name: { type: 'string', example: 'John Doe' },
              email: { type: 'string', example: 'john@example.com' },
              organisation_id: { type: 'integer', example: 1 },
              organisation_name: { type: 'string', example: 'ACME Corp' },
              status: { type: 'string', enum: ['active', 'departed'], example: 'active' }
            },
            required: ['id', 'name', 'email', 'status']
          },
          Error: {
            type: 'object',
            properties: {
              error: { type: 'string' }
            },
            required: ['error']
          }
        }
      },
      servers: [
        {
          url: '{protocol}://{hostname}:{port}',
          variables: {
            protocol: {
              enum: ['http', 'https'],
              default: 'http'
            },
            hostname: {
              enum: ['localhost', 'hindsite.example.com'],
              default: 'localhost'
            },
            port: {
              enum: ['3000', '80', '443'],
              default: '3000'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
