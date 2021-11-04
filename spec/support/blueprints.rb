require "machinist/active_record"

User.blueprint do
  email { "#{sn}@example.com" }
  password { "123456" }
  password_confirmation { "123456" }
#   session { Session.make! }
end

Session.blueprint do
    user { User.make! }
    expiry_at { Time.current + Session::TTL }
end

Workout.blueprint do
    user { User.make! }
    workout_at { Time.current }
    duration { 40 }
end