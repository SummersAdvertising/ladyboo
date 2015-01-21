# encoding: utf-8
class DailyReport < ActiveRecord::Base
  
  has_many :revenue_details
  
  scope :latest_report , -> { order(created_at: :desc).first }
  scope :list_by_created , -> { order(created_at: :desc) }

  delegate :sum_by_category, :sum_by_product, :sum_by_stock, to: :revenue_details

  paginates_per 25

  def sum_it_up(type)
    
    case(type)
      when "ByCategory"
        self.sum_by_category.sum(:figure)
      when "ByProduct"
        self.sum_by_product.sum(:figure)
      when "ByStock"
        self.sum_by_stock.sum(:figure)
    end

  end

  def list_by_type(type)
    case(type)
      when "ByCategory"
        self.sum_by_category
      when "ByProduct"
        self.sum_by_product
      when "ByStock"
        self.sum_by_stock
    end    
  end

  def self.slice_by_date_range(begin_date = Date.today - 7.days, end_date = Date.today)
    DailyReport.where(target_date: begin_date.beginning_of_day..end_date.end_of_day).order(created_at: :desc)
  end

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
    total_order_count = Order.where(created_at: target_date.beginning_of_day..target_date.end_of_day).count  
    
    # 當日新成立之訂單數量
    valid_order_count = Order.where(created_at: target_date.beginning_of_day..target_date.end_of_day).where.not(aasm_state: 'hold').count
    
    # 當日所有進入最後一步未完成結賬
    onhold_order_count = Order.where(aasm_state: 'hold').where(created_at: target_date.beginning_of_day..target_date.end_of_day).count 
    
    # 當日完成之訂單數量
    completed_order_ids_today = Order.where(aasm_state: 'close').where(updated_at: target_date.beginning_of_day..target_date.end_of_day).pluck(:id) 
    completed_order_count = completed_order_ids_today.count 

    cancel_order_count = Order.where(aasm_state: 'cancel').where(updated_at: target_date.beginning_of_day..target_date.end_of_day).count
    abnormal_end_order_count = Order.where(aasm_state: 'abnormal').where(updated_at: target_date.beginning_of_day..target_date.end_of_day).count

    # 當日完成之訂單, 運費營業額總計
    total_shipping_revenue = Order.where(id: completed_order_ids_today).sum(:shipping_fee)
    # 當日完成之訂單, 商品營業額總計
    total_product_revenue = Orderitem.where(order_id: completed_order_ids_today).sum('item_price * amount')

    # 當日新會員數量
    new_member_count = User.where(created_at: target_date).count 

    @report_today = DailyReport.create({name: target_date.strftime("%Y-%m-%d"),total_order_count: total_order_count, valid_order_count: valid_order_count, onhold_order_count: onhold_order_count,completed_order_count: completed_order_count,cancel_order_count: cancel_order_count, abnormal_end_order_count: abnormal_end_order_count,total_shipping_revenue: total_shipping_revenue, total_product_revenue: total_product_revenue,new_member_count: new_member_count, run_at: Time.now.in_time_zone('Taipei'), target_date: target_date})

    if @report_today.save      
      #營業額分項 by_category
      sumup_by_category = Orderitem.where(order_id: completed_order_ids_today).joins('LEFT OUTER JOIN stocks ON stocks.id = orderitems.stock_id LEFT OUTER JOIN products ON stocks.product_id = products.id LEFT OUTER JOIN categories ON products.category_id = categories.id').group(:category_id).sum('orderitems.item_price*orderitems.amount')
      sumup_by_category.each do |data|
        
        category_name = (Category.find(data[0]).name if Category.exists?(data[0]) ) || '其他'
        product_name = '其他'
        stock_name = '其他'

        display_name = RevenueDetail.combine_display_name(category_name)

        @report_today.revenue_details.create({context_id: data[0], context_displayname: display_name, category_name: category_name, product_name: product_name, stock_name: stock_name, figure: data[1],type: 'SumByCategory'})
      end
      
      #營業額分項 by_product
      sumup_by_product = Orderitem.where(order_id: completed_order_ids_today).joins('LEFT OUTER JOIN stocks ON stocks.id = orderitems.stock_id LEFT OUTER JOIN products ON stocks.product_id = products.id LEFT OUTER JOIN categories ON products.category_id = categories.id').group(:product_id).sum('orderitems.item_price*orderitems.amount')
      sumup_by_product.each do |data|

        if Product.exists?(data[0])
          this_product = Product.find(data[0])
          product_name = this_product.name
          if Category.exists?(this_product.category)
            category_name = this_product.category.name
          else
            category_name = '其他'
          end
        else
          product_name = '其他'
        end

        stock_name = '其他'
        display_name = RevenueDetail.combine_display_name(category_name, product_name)
        
        @report_today.revenue_details.create({context_id: data[0], context_displayname: display_name, category_name: category_name, product_name: product_name, stock_name: stock_name, figure: data[1],type: 'SumByProduct'})
      end

      #營業額分項 by_stock
      sumup_by_stock = Orderitem.where(order_id: completed_order_ids_today).joins('LEFT OUTER JOIN stocks ON stocks.id = orderitems.stock_id LEFT OUTER JOIN products ON stocks.product_id = products.id LEFT OUTER JOIN categories ON products.category_id = categories.id').group(:stock_id).sum('orderitems.item_price*orderitems.amount')
      sumup_by_stock.each do |data|
        
        if Stock.exists?(data[0])
          this_stock = Stock.find(data[0])
          stock_name = this_stock.name
          if Product.exists?(this_stock.product)
            this_product = this_stock.product
            product_name = this_product.name
            if Category.exists?(this_product.category)
              category_name = this_product.category.name
            else
              category_name = '其他'
            end
          else
            product_name = '其他'
          end
        else
          stock_name = '其他'
        end

        display_name = RevenueDetail.combine_display_name(category_name, product_name, stock_name)

        @report_today.revenue_details.create({context_id: data[0], context_displayname: display_name, category_name: category_name, product_name: product_name, stock_name: stock_name, figure: data[1],type: 'SumByStock'})
      end

    end
  end

end
