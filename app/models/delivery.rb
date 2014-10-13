class Delivery < ActiveRecord::Base
  validates_presence_of :name, :tracking_url, :normal_fee, :discount_fee, :discount_criteria
  validates_numericality_of :normal_fee, :discount_fee, :discount_criteria, :only_integer => true
end
