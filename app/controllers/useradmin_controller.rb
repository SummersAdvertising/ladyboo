class UseradminController < ApplicationController
  authorize_resource
  before_action :authenticate_user!
  before_action :current_ability
  before_action :check_cart
  # before_action :fetch_for_nav

  layout "useradmin"

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
    # exception.action, exception.subject
  end

  private

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
  
  def check_cart
    @items_in_cart = Cart.check_items_in_cart(cookies[:cart_ladyboo], "for_cart")
  end

  # def fetch_for_nav
  #   @root_node = Category.return_root_node
  #   @hierarchy = Category.get_level_hierarchy()
  #   @lookbook = Lookbook.where(status: 'enable').first
  # end
  
end
