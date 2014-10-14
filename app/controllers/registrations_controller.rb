#encoding: utf-8
class RegistrationsController < Devise::RegistrationsController

  def create
    if verify_recaptcha
      super
      LadyboomailerJob.new.async.perform(LadybooMailer, :welcome, @user) unless @user.invalid?
      #CamaMailer.welcome(@user).deliver unless @user.invalid?
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash.now[:alert] = "驗證碼錯誤"
      flash.delete :recaptcha_error
      render :new
    end
  end

end