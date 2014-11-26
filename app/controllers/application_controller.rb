class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :fetch_for_nav
  before_action :check_cart

  layout :layout_by_resource

  def record_login_redirect_path
    session["user_return_to"] = "#{request.fullpath}"
  end

  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to root_url, alert: exception.message
    redirect_to :back, alert: exception.message
    # exception.action, exception.subject
  end

  private
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation ,:username, :address, :tel, :birthday) }
  end

  def layout_by_resource
    if devise_controller? && resource_name == :admin
      "admin_sign_in"
    elsif devise_controller? && resource_name == :user
      "devise"
    else
      "application"
    end
  end

  def fetch_for_nav
    @root_node = Category.return_root_node
    @hierarchy = Category.get_level_hierarchy()
    @lookbook = Lookbook.where(status: 'enable').first
    @topic_collections = TopicCollection.where(status: 'enable').all.limit(4)
    @q = Product.where(status: 'enable').search()
  end
  
  def check_cart
    @items_in_cart = Cart.check_items_in_cart(cookies[:cart_ladyboo], "for_cart")
  end

end
