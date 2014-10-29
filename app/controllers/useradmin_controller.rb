class UseradminController < ApplicationController
  authorize_resource
  before_action :authenticate_user!
  before_action :current_ability

  layout "useradmin"

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
    # exception.action, exception.subject
  end

  private

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
  
end
