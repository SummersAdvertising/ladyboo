# encoding: utf-8
class RevenueDetail < ActiveRecord::Base
  belongs_to :daily_report

  scope :sum_by_category, -> { where(type: 'SumByCategory').order(:category_name, :product_name, :stock_name).limit(10) } 
  scope :sum_by_product, -> { where(type: 'SumByProduct').order(:category_name, :product_name, :stock_name).limit(10) } 
  scope :sum_by_stock, -> { where(type: 'SumByStock').order(:category_name, :product_name, :stock_name).limit(10) }

  def self.types
    %w(SumByCategory SumByProduct SumByStock)
  end

  def self.show_top_ten_revenue(*daily_report_id)
    is_return_all = false
    is_length_zero = false

    unless daily_report_id.blank?
      category_revenue_details = RevenueDetail.where(daily_report_id: daily_report_id).top_ten_by_type('ByCategory')
      product_revenue_details = RevenueDetail.where(daily_report_id: daily_report_id).top_ten_by_type('ByProduct')
      stock_revenue_details = RevenueDetail.where(daily_report_id: daily_report_id).top_ten_by_type('ByStock')
    else
      category_revenue_details = RevenueDetail.top_ten_by_type('ByCategory')
      product_revenue_details = RevenueDetail.top_ten_by_type('ByProduct')
      stock_revenue_details = RevenueDetail.top_ten_by_type('ByStock')
      is_return_all = true
    end

    if category_revenue_details.length == 0
      is_length_zero = true
    end

    return [ is_return_all, is_length_zero, category_revenue_details, product_revenue_details, stock_revenue_details ]
  end

  def self.top_ten_by_type(type)
    case(type)
      when "ByCategory"
        RevenueDetail.sum_by_category.group(:category_name,:product_name).sum(:figure).sort_by{|k,v| v}.reverse
      when "ByProduct"
        RevenueDetail.sum_by_product.group(:category_name,:product_name).sum(:figure).sort_by{|k,v| v}.reverse
      when "ByStock"
        RevenueDetail.sum_by_stock.group(:category_name,:product_name, :stock_name, :context_displayname).sum(:figure).sort_by{|k,v| v}.reverse
    end    
  end

  def self.combine_display_name(category_name = "其他", product_name = "其他", stock_name = "其他")

    display_name = "#{category_name} - "
    display_name = display_name + "#{product_name} - "
    display_name = display_name + "#{stock_name}"

    return display_name
    
  end

end

class SumByCategory < RevenueDetail
end

class SumByProduct < RevenueDetail
end

class SumByStock < RevenueDetail
end
