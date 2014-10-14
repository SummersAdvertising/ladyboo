#encoding: utf-8
class Useradmin::UsersController < UseradminController
  layout 'useradmin'

  before_action :authenticate_user!
  
  def index

    @user = current_user #User.find_by_id(current_user.id)

  end

  def update
    
    if current_user.id.to_s == params[:id].to_s
      @user = current_user
    
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      respond_to do | format |
        if !@user.nil? && @user.update_attributes( user_params )
          format.html { redirect_to useradmin_users_path, notice: "資料已更新" }
        else
          p @user.errors.full_messages
          format.html { redirect_to useradmin_users_path, notice: @user.errors.full_messages }
        end
      end
    
    else
      redirect_to useradmin_users_path, warning: "Access denied."
    end

  end


  private

  def user_params
    params.require(:user).permit( :username, :email, :password, :password_confirmation, :tel, :address )
  end

end
