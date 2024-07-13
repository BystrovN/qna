# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer]
    can :add_comment, [Question, Answer]
    can %i[update destroy], [Question, Answer] do |resource|
      user.author_of?(resource)
    end
    can %i[vote_up vote_down], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end
    can :best, Answer do |answer|
      user.author_of?(answer.question)
    end
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end
  end
end
