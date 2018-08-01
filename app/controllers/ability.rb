class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, Execution, :user_id => user.id
    can :create, Execution

    #can :manage, Workflow, :user_id => user.id
    #can :create, Workflow

    can :manage, UploadedFile, :user_id => user.id
    can :create, UploadedFile
  end
end
