#encoding: utf-8
class Admin::OrdersController < AdminController
  #authorize_resource
  
  layout :resolve_layout
  before_action :authenticate_admin!

  helper_method :sort_column, :sort_direction

  before_action :set_order, :except => [:index, :shipped, :pending, :human_involved, :history, :detail]
  #before_action :need_mail, :only => [:checkout_succeeded_ATM, :checkout_succeeded_Vaccount, :checkout_succeeded_COD, :checkout_succeeded_general, :shipping, :shipping_first, :shipping_COD]

  def index
    @q = Order.todolist.search(params[:q])
    @orders = @q.result(distinct: true).page(params[:page])
    #@orders = Order.todolist.order(sort_column + " " + sort_direction)
  end

  def shipped
    @q = Order.shipped.search(params[:q])
    @orders = @q.result(distinct: true).page(params[:page])
    #@orders = Order.shipped.order(sort_column + " " + sort_direction)
  end

  def pending
    @q = Order.pending.search(params[:q])
    @orders = @q.result(distinct: true).page(params[:page])
    #@orders = Order.pending.order(sort_column + " " + sort_direction)
  end

  def human_involved
    @q = Order.human_involved.search(params[:q])
    @orders = @q.result(distinct: true).page(params[:page])
    #@orders = Order.human_involved.order(sort_column + " " + sort_direction)
  end

  def history
    @q = Order.history.search(params[:q])
    @orders = @q.result(distinct: true).includes(:user).page(params[:page])
    # query options
    @payment_type_eq = {'-- 請選擇 --' => nil, 'ATM' => 'atm_transfer', '信用卡' => 'credit_card', 'Paypal' => 'paypal' }
    @payment_status_eq = {'-- 請選擇 --' => nil, '交易完成' => 'finished', '交易結束' => 'abnormal_end', '取消訂單' => 'cancel', '交易失敗' => 'failed' }
    @paid_eq = {'-- 請選擇 --' => nil, '已付款' => 'yes', '未付款' => 'no' }
    @shipped_eq = {'-- 請選擇 --' => nil, '已出貨' => 'yes', '未出貨' => 'no' }
    @created_at_gteq = {'-- 請選擇 --' => nil, '1週' => 1.week.ago, '1個月' => 1.month.ago, '1年'=> 1.year.ago }
    #@orders = Order.history.order(sort_column + " " + sort_direction).page(params[:page])
  end

  def show
    @order = Order.includes(:orderitems).find_by_id(params[:id])

    respond_to do |format|
      if(@order)
        format.html
        format.js
      else
        format.html { redirect_to :back, alert: "找不到訂單" }
      end
    end
  end
  
  def detail

    @order = Order.includes(:orderitems).find_by_id(params[:id])
    @user = User.find_by_id(@order.user_id)

    respond_to do |format|
      if(@order)
        format.html
      else
        format.html { redirect_to :back, alert: "找不到訂單" }
      end
    end

  end

  def info_hub

  end
  # AASM event
  def cancel_before_paid
    @order.cancel_before_paid!    
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end

  # ATM
  def cancel_before_paid_ATM
    @order.cancel_before_paid_ATM!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end

  def atm_transfered
    @order.atm_transfered!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end

  def checkout_succeeded_ATM
    @order.checkout_succeeded_ATM!
    redirect_to :back
  end

  def atm_comfirmed
    #check 5
    @order.atm_comfirmed!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end
  ######## ATM END ########

  #Vaccount
  def checkout_succeeded_Vaccount
    @order.checkout_succeeded_Vaccount!
    redirect_to :back
  end
  
  def cancel_before_paid_Vaccount
    @order.cancel_before_paid_Vaccount!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'#redirect_to :back
  end
  
  def comfirmed_Vaccount
    @order.comfirmed_Vaccount!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'#redirect_to :back
  end

  ######## Vaccount END ########
  # COD
  def checkout_succeeded_COD
    @order.checkout_succeeded_COD!
    redirect_to :back
  end

  def shipping_COD
    @order.update_column(:package_tracking_no, params[:order][:package_tracking_no]) unless params[:order][:package_tracking_no].nil?
    @order.shipping_COD!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end
  
  def post_collect_checked
    @order.post_collect_checked!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end

  def human_involving_after_order_placed_COD
    @order.update(admin_order_params)
    @order.human_involving_after_order_placed_COD!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end

  def human_involving_post_collect_COD
    @order.update(admin_order_params)
    @order.human_involving_post_collect_COD!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end
  # COD END

  # General
  def checkout_succeeded_general
    @order.checkout_succeeded_general!
    redirect_to :back
  end

  def shipping_first
    @order.update_column(:package_tracking_no, params[:order][:package_tracking_no]) unless params[:order][:package_tracking_no].nil?
    @order.shipping_first!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end

  def human_involving_after_order_placed_general
    @order.update(admin_order_params)
    @order.human_involving_after_order_placed_general!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end
  ######## General END ########
  def checkout_failed
    @order.checkout_failed!
    redirect_to :back
  end
  def human_involving_after_money_placed
    @order.update(admin_order_params)
    @order.human_involving_after_money_placed!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end

  def human_involving_after_money_checked
    @order.update(admin_order_params)
    @order.human_involving_after_money_checked!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end
  
  def human_involving_after_shipped
    @order.update(admin_order_params)
    @order.human_involving_after_shipped!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end
  
  def human_involved_edit
    @order.update(admin_order_params)
    @order.human_involved_edit!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'#redirect_to :back
  end

  def shipping

    @order.update_column(:package_tracking_no, params[:order][:package_tracking_no]) unless params[:order][:package_tracking_no].nil?
    
    @order.shipping!
    
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'
  end

  def close_deal
    @order.close_deal!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'#redirect_to :back
  end

  def to_abnormal
    @order.to_abnormal!
    render :text => '<script type="text/javascript">parent.jQuery.colorbox.close(); </script>'#redirect_to :back
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.includes(:orderitems).find_by_id(params[:id])
    @order.subscribe(Orderlog.new)
  end
  
  def admin_order_params
    params.require(:order).permit(:package_tracking_no, :human_involved_memo)
  end

  def resolve_layout
    case action_name
    when "info_hub" 
        return "clean"  
    else
      return "admin"
    end
  end

end