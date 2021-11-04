require "swagger_helper"

RSpec.describe "users", type: :request do
  let(:'Content-Type') { "application/json" }

  path "/users" do
    post "create user" do
      tags "Users"
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true

      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          email: {
            type: :string,
            description: "The user email",
            example: "fitbod@example.com",
            required: true,
          },
          password: {
            type: :string,
            description: "The user password",
            example: "123456",
            required: true,
          },
          password_confirmation: {
            type: :string,
            description: "The user password confirmation",
            example: "123456",
            required: true,
          },
        },
      }

      let(:request_body) {
        {
          email: "fitbod@example.com",
          password: "password",
          password_confirmation: "password",
        }
      }

      response "201", "Created" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to_not be_empty
          expect(data).to include(
            "email" => "fitbod@example.com",
          )
        end
      end

      response "422", "Unprocessable Entity" do
        let(:request_body) {
          {
            password: "password",
            password_confirmation: "password",
          }
        }

        run_test!
      end
    end
  end

  path "/users/{id}" do
    let!(:user) { User.make!(email: "fitbod@example.com", password: "password", password_confirmation: "password") }
    let!(:api_key) { "Bearer #{Session.make!(user: user).token}" }
    let!(:Authorization) { api_key }

    patch "update user" do
      tags "Users"
      security [JWT: []]
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true
      parameter name: "id", in: :path, type: :string, description: "id"

      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          email: {
            type: :string,
            description: "The user email",
            example: "fitbod@example.com",
            required: true,
          },
          password: {
            type: :string,
            description: "The user password",
            example: "123456",
            required: true,
          },
          password_confirmation: {
            type: :string,
            description: "The user password confirmation",
            example: "123456",
            required: true,
          },
        },
      }

      let(:request_body) {
        {
          email: "fitbod2@example.com",
          password: "password1",
          password_confirmation: "password1",
        }
      }

      response "200", "OK" do
        let(:id) { user.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to_not be_empty
          expect(data).to include(
            "email" => "fitbod2@example.com",
          )
        end
      end
    end

    get "show user" do
      tags "Users"
      security [JWT: []]
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true
      parameter name: "id", in: :path, type: :string, description: "id"

      response "200", "OK" do
        let(:id) { user.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to_not be_empty
          expect(data).to include(
            "email" => "fitbod@example.com",
          )
        end
      end

      response "401", "Unathorized" do
        let!(:Authorization) { "Bearer invalid_token" }
        let(:id) { user.id }
        run_test! 
      end

      response "401", "Unathorized" do
        let!(:api_key) { "Bearer #{Session.make!(user: user, expiry_at: Time.current - 3.year).token}" }
        let!(:Authorization) { api_key }
        let(:id) { user.id }
        run_test! 
      end
    end
  end
end
