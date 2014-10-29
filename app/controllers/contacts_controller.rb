# encoding: utf-8
class ContactsController < ApplicationController

  def index
    @contact = Contact.new
  end

  def create

    if verify_recaptcha
      @contact = Contact.new(contact_params)

      respond_to do |format|
        if @contact.save

          # MAIL
          LadyboomailerJob.new.async.perform(LadybooMailer, :contact, @contact)
          format.html { redirect_to root_url, notice: '感謝您的留言，我們會儘快與您連絡。' }
        
        else
          flash[ :alert ] = @contact.errors.messages.values.flatten.join('<br />')
          format.html { render template: 'contacts/index'}
        end
      end

    else
      @contact = Contact.new
      flash.now[:alert] = "驗證碼錯誤"
      flash.delete :recaptcha_error
      render :index
    end
  end


  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :content)#,{:purpose => []}
  end

end
