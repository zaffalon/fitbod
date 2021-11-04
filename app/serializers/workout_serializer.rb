class WorkoutSerializer
  include JSONAPI::Serializer
  attributes :workout_at, :duration
  belongs_to :user
end
