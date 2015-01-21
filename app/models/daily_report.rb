# encoding: utf-8
class DailyReport < ActiveRecord::Base
  
  has_many :revenue_details
  
  def self.calculate_yesterday
    DailyReport.calculate_report_of(Date.today - 1.day)
  end

  def self.calculate_by_range(begin_date = Date.today - 100.days , end_date = Date.today)
    cal_range = (end_date - begin_date).to_i

    for i in 0..cal_range-1
      DailyReport.calculate_report_of(begin_date + i.day)
    end

  end

  def self.calculate_report_of(target_date)
    # 當日總訂單數量
    total_order_count = Order.where(created_at: target_date.beginning_of_day..target_date.end_of_day).count  #還要加日期限制 where(created_at: Date.today-1)
    
    # 當日新成立之訂單數量
    valid_order_count = Order.where(created_at: target_date.beginning_of_day..target_date.end_of_day).where.not(aasm_state: 'hold').count  #還要加日期限制
    
    # 當日所有進入最後一步未完成結賬
    onhold_order_count = Order.where(aasm_state: 'hold').where(created_at: target_date.beginning_of_day..target_date.end_of_day).count  #還要加日期限制
    
    # 當日完成之訂單數量
    completed_order_ids_today = Order.where(aasm_state: 'close').where(updated_at: target_date.beginning_of_day..target_date.end_of_day).pluck(:id)  #還要加日期限制
    # all complete orders (collect more for test)
    # completed_order_ids_today = Order.where(aasm_state: 'close').pluck(:id)  #還要加日期限制
    completed_order_count = completed_order_ids_today.count 

    cancel_order_count = Order.where(aasm_state: 'cancel').where(updated_at: target_date.beginning_of_day..target_date.end_of_day).count
    abnormal_end_order_count = Order.where(aasm_state: 'abnormal').where(updated_at: target_date.beginning_of_day..target_date.end_of_day).count

    # 當日完成之訂單, 運費營業額總計
    total_shipping_revenue = Order.where(id: completed_order_ids_today).sum(:shipping_fee)
    # 當日完成之訂單, 商品營業額總計
    total_product_revenue = Orderitem.where(order_id: completed_order_ids_today).sum('item_price * amount')

    # 當日新會員數量
    new_member_count = User.where(created_at: target_date).count  #還要加日期限制

    @report_today = DailyReport.create({name: target_date.strftime("%Y-%m-%d"),total_order_count: total_order_count, valid_order_count: valid_order_count, onhold_order_count: onhold_order_count,completed_order_count: completed_order_count,cancel_order_count: cancel_order_count, abnormal_end_order_count: abnormal_end_order_count,total_shipping_revenue: total_shipping_revenue, total_product_revenue: total_product_revenue,new_member_count: new_member_count, run_at: Time.now.in_time_zone('Taipei'), target_date: target_date})

    if @report_today.save      
      #營業額分項 by_category
      sumup_by_category = Orderitem.where(order_id: completed_order_ids_today).joins('LEFT OUTER JOIN stocks ON stocks.id = orderitems.stock_id LEFT OUTER JOIN products ON stocks.product_id = products.id LEFT OUTER JOIN categories ON products.category_id = categories.id').group(:category_id).sum('orderitems.item_price*orderitems.amount')
      sumup_by_category.each do |data|
        name = (Category.find(data[0]).name if Category.exists?(data[0]) ) || '其他'
        @report_today.revenue_details.create({context_id: data[0], context_displayname: name, figure: data[1],type: 'SumByCategory'})
      end
      
      #營業額分項 by_product
      sumup_by_product = Orderitem.where(order_id: completed_order_ids_today).joins('LEFT OUTER JOIN stocks ON stocks.id = orderitems.stock_id LEFT OUTER JOIN products ON stocks.product_id = products.id LEFT OUTER JOIN categories ON products.category_id = categories.id').group(:product_id).sum('orderitems.item_price*orderitems.amount')
      sumup_by_product.each do |data|
        name = (Product.find(data[0]).name if Product.exists?(data[0]) ) || '其他'
        @report_today.revenue_details.create({context_id: data[0], context_displayname: name, figure: data[1],type: 'SumByProduct'})
      end

      #營業額分項 by_stock
      sumup_by_stock = Orderitem.where(order_id: completed_order_ids_today).joins('LEFT OUTER JOIN stocks ON stocks.id = orderitems.stock_id LEFT OUTER JOIN products ON stocks.product_id = products.id LEFT OUTER JOIN categories ON products.category_id = categories.id').group(:stock_id).sum('orderitems.item_price*orderitems.amount')
      sumup_by_stock.each do |data|
        name = (Stock.find(data[0]).name if Stock.exists?(data[0]) ) || '其他'
        @report_today.revenue_details.create({context_id: data[0], context_displayname: name, figure: data[1],type: 'SumByStock'})
      end

    end
  end

end
