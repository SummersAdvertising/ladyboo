#encoding: utf-8
class Useradmin::AddressbooksController < UseradminController

  before_action :authenticate_user!
  before_action :set_user, :only => [:index, :create]
  before_action :set_addressbook, :only => [:update, :destroy]

  def index
    @addressbooks = @user.addressbooks.latest
    @new_addressbook = Addressbook.new
  end

  def create
    @addressbook = @user.addressbooks.new(addressbook_params)
    @addressbook.save if @addressbook

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def update

    respond_to do | format |
      if @addressbook && @addressbook.update_attributes( addressbook_params )
        format.html { redirect_to useradmin_addressbooks_path }
      else
        format.html { render :edit }
      end
    end

  end

  def destroy

    if @addressbook
      @addressbook.destroy 
    end

    redirect_to :back

  end

  private
  

  def set_user
    @user = User.find(current_user)
  end

  def set_addressbook
    @addressbook = current_user.addressbooks.find( params[ :id ] )    
  end

  def addressbook_params
    params.require(:addressbook).permit( :name, :address )
  end

end