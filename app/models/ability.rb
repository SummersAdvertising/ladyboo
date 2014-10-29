class Ability
  #ability of user
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new

    if user.blank?  
      # not logged in 如果user沒登入
      cannot :manage, :all  #設置無法管理任何資源
      can :read, :all

    elsif user.has_role?(:member)
      
      # can :update, Order do |order|
      #   (order.user_id == user.id)
      # end

      can :atm_transfered, Order do |order|
        (order.user_id == user.id)
      end
      
      can :update, User do |theuser|
        (theuser.id == user.id)
      end

      #can :create, Addressbook
      can :manage, Addressbook do |addressbook|
        (addressbook.user_id == user.id)
      end

      can :manage, TrackingList do |tracking_list|
        (tracking_list.user_id == user.id)
      end

      can :create, Orderask

      can :read, :all

    else

      cannot :manage, :all  #設置無法管理任何資源
      can :read, :all

    end

  end

  private

  # def basic_read_only
  #   can :read,    Wrkrec
  # end


end
