require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:user) { }

  subject(:ability) { described_class.new(user) }

  describe 'base permissions for everything' do
    context 'with no user' do
      it 'should not be able to manage base permissions for everything' do
        is_expected.to_not be_able_to(:manage, Session)
        is_expected.to_not be_able_to(:read, User)
        is_expected.to_not be_able_to(:update, User)
        is_expected.to_not be_able_to(:manage, Workout)
      end
    end
  end

  describe 'base permissions for users' do
    context 'with user' do
      let!(:user) { User.make! }
      let!(:session) { Session.make!(user: user) }
      let!(:workout) { Workout.make!(user: user) }

      it 'should be able to manage base user permissions' do
        is_expected.to be_able_to(:manage, session)
        is_expected.to be_able_to(:read, user)
        is_expected.to be_able_to(:update, user)
        is_expected.to be_able_to(:manage, workout)
      end
    end
  end
end
