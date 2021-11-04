# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :manage, Session, user_id: user.id
    can [:read, :update], User, id: user.id
    can :manage, Workout, user_id: user.id

  end
end
