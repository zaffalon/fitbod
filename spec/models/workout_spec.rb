require 'rails_helper'

RSpec.describe Workout, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of(:workout_at) }
  it { should validate_presence_of(:duration) }
end
