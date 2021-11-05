class WorkoutSerializer
  include JSONAPI::Serializer
  attributes :workout_at, :duration, :created_at
  belongs_to :user
end
