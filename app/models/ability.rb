class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil? #guest
      # more to be added later
    elsif user.admin?
      can :manage, :all
    else
      # user permission
    end
  end
end
