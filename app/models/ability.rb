class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can :manage, :all
    else
      can :read, Page, ["publish_at <= ?", Time.zone.now] do |page|
        page.publish_at <= Time.zone.now
      end
    end
  end
end
