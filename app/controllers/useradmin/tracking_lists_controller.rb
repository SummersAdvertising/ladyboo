#encoding: utf-8
class Useradmin::TrackingListsController < UseradminController

  before_action :authenticate_user!
  before_action :set_user, :only => [:index, :create]
  before_action :set_tracking_list, :only => [:update, :destroy]

  def index
    # available_products_id = Product.where(status:'enable').pluck(:id)
    @user.tracking_lists.where.not(product_id: Product.where(status:'enable').pluck(:id)).destroy_all
    @tracking_lists = @user.tracking_lists.latest
    @new_tracking_list = TrackingList.new
  end

  def create

    if @user 
      unless @user.tracking_lists.pluck(:product_id).include?(tracking_list_params[:product_id].to_i)
        @tracking_list = @user.tracking_lists.new(tracking_list_params)
        @tracking_list.save if @tracking_list
      end
    end 

    respond_to do | format |
      if @tracking_list
        format.html { redirect_to :back , notice: "已加入追蹤" }
      else
        format.html { redirect_to :back }
      end
    end

  end

  def update

    respond_to do | format |
      if @tracking_list && @tracking_list.update_attributes( tracking_list_params )
        format.html { redirect_to useradmin_tracking_lists_path }
      else
        format.html { render :edit }
      end
    end

  end

  def destroy

    if @tracking_list
      @tracking_list.destroy 
    end

    redirect_to :back

  end

  private
  

  def set_user
    @user = User.find(current_user)
  end

  def set_tracking_list
    @tracking_list = current_user.tracking_lists.find( params[ :id ] )    
  end

  def tracking_list_params
    params.require(:tracking_list).permit( :user_id, :product_id )
  end

end