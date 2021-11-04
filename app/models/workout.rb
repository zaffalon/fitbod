#encoding: utf-8

class Workout < ApplicationRecord
  belongs_to :user

  validates_presence_of :workout_at, :duration
end
