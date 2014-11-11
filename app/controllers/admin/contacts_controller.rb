class Admin::ContactsController < AdminController
  #authorize_resource
  
  def index
    @contacts = Contact.new_asks.page(params[:page])
  end

  def history
    @contacts = Contact.history_asks.page(params[:page])
  end

  def update
    @contact = Contact.find_by_id(params[:id])

    if(@contact)
      @contact.status = "done"
      @contact.save
    end
    
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
end