class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      # more to be added later
    elsif user.admin?
      can :manage, :all
    else
      can :read, :id => user.id
    end
  end
end
