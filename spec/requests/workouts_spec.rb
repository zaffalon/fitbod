require "swagger_helper"

RSpec.describe "workouts", type: :request do
  let!(:'Content-Type') { "application/json" }
  let!(:user) { User.make! }
  let!(:api_key) { "Bearer #{Session.make!(user: user).token}" }
  let!(:Authorization) { api_key }

  path "/workouts" do
    get "list workouts" do
      tags "Workouts"
      let!(:workout) { Workout.make!(user: user) }

      security [JWT: []]
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true

      parameter name: :last_updated_at, in: :query, type: :string, example: "2021-10-01 20:00:00", description: "Used to polling API for the last workouts, pass the last created_at persisted in API and updated in the device storage", required: false
      parameter name: :page, in: :query, type: :integer, example: 1, description: "Page number you are searching", required: false

      response "200", "Workouts returned successfully" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]).to include(hash_including("id" => workout.id))
          expect(data["data"].count).to eq(1)
        end
      end

      response "200", "Return empty" do
        let(:last_updated_at) { workout.created_at + 1.minutes }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]).to be_empty
        end
      end

      response "200", "Return last workouts created" do
        let!(:workout1) { Workout.make!(user: user, created_at: Time.current + 10.minutes) }
        let!(:workout2) { Workout.make!(user: user, created_at: Time.current + 5.minutes) }
        let!(:workout3) { Workout.make!(created_at: Time.current + 5.minutes) }

        let(:last_updated_at) { workout.created_at + 1.minutes }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"].size).to eq(2)
          expect(data["data"]).to include(hash_including("id" => workout1.id))
          expect(data["data"]).to include(hash_including("id" => workout2.id))
        end
      end
    end

    post "create workout" do
      tags "Workouts"
      security [JWT: []]
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true

      parameter name: :request_body, in: :body,  required: true, schema: {
        type: :object,
        properties: {
          duration: {
            type: :integer,
            description: "The total duration in minutes",
            example: "45",
            required: true,
          },
          workout_at: {
            type: :string,
            description: "The datetime that workout begins",
            example: "2021-10-01 20:00:00",
            required: true,
          },
        },
      }

      let!(:current_time) { Time.current }

      let(:request_body) {
        {
          duration: 45,
          workout_at: current_time,
        }
      }

      response "201", "Created" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]).to_not be_empty
          expect(data["data"]).to include("id" => anything)
          expect(data["data"]["attributes"]).to include(
            "duration" => 45,
            "workout_at" => anything,
          )
          expect(data["data"]["attributes"]["workout_at"].to_datetime.to_i).to eq(current_time.to_i)
        end
      end

      response "422", "Unprocessable Entity" do
        let(:request_body) {
          {
            workout_at: current_time,
          }
        }

        run_test!
      end
    end
  end

  path "/workouts/{id}" do
    let!(:workout) { Workout.make!(user: user) }
    let!(:id) { workout.id }

    get "show workout" do
      tags "Workouts"
      security [JWT: []]
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true
      parameter name: "id", in: :path, type: :string, description: "id"

      response "200", "OK" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]).to_not be_empty
          expect(data["data"]).to include("id" => workout.id)
          expect(data["data"]["attributes"]).to include(
            "duration" => workout.duration,
            "workout_at" => anything,
          )
        end
      end
    end

    patch "update workout" do
      tags "Workouts"
      security [JWT: []]
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true
      parameter name: "id", in: :path, type: :string, description: "id"

      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          duration: {
            type: :integer,
            description: "The total duration in minutes",
            example: "45",
            required: true,
          },
          workout_at: {
            type: :string,
            description: "The datetime that workout begins",
            example: "2021-10-01 20:00:00",
            required: true,
          },
        },
      }

      let!(:current_time) { Time.current }

      let(:request_body) {
        {
          duration: 50,
          workout_at: current_time,
        }
      }

      response "200", "OK" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]).to_not be_empty
          expect(data["data"]).to include("id" => workout.id)
          expect(data["data"]["attributes"]).to include(
            "duration" => 50,
            "workout_at" => anything,
          )
          expect(data["data"]["attributes"]["workout_at"].to_datetime.to_i).to eq(current_time.to_i)
        end
      end
    end

    delete "delete workout" do
      tags "Workouts"
      security [JWT: []]
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true
      parameter name: "id", in: :path, type: :string, description: "id"

      response "204", "OK" do
        run_test! do |response|
          expect(response.body).to be_empty
        end
      end
    end
  end
end
