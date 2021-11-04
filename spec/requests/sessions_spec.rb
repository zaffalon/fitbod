require "swagger_helper"

RSpec.describe "sessions", type: :request do
  let(:'Content-Type') { "application/json" }
  let!(:user) { User.make!(email: "fitbod@example.com", password: "password", password_confirmation: "password") }
  let!(:api_key) { "Bearer #{Session.make!(user: user).token}" }
  let!(:Authorization) { api_key }

  path "/sessions" do
    post "create session" do
      tags "Sessions"
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
            example: "12345678",
            required: true,
          },
        },
      }

      let(:request_body) {
        {
          email: "fitbod@example.com",
          password: "password",
        }
      }

      response "201", "Created" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to_not be_empty
          expect(data).to include(
            "token" => anything,
          )
        end
      end

      response "422", "Unprocessable Entity" do
        let(:request_body) {
          {
            email: "invalid@example.com",
            password: "password",
          }
        }

        run_test!
      end

      response "422", "Unprocessable Entity" do
        let(:request_body) {
          {
            password: "password",
          }
        }

        run_test!
      end

      response "422", "Unprocessable Entity" do
        let(:request_body) {
          {
            email: "fitbod@example.com",
            password: "invalid",
          }
        }

        run_test!
      end
    end
  end
end
