#encoding: utf-8
class Product < ActiveRecord::Base

  belongs_to :category
  has_many :pickups, dependent: :destroy
  has_many :measurements, dependent: :destroy
  has_many :galleries, -> { order('ranking, created_at') } , as: :attachable , dependent: :destroy

  has_many :topic_productships, dependent: :destroy
  has_many :topics , through: :topic_productships

  scope :front_show_by_cate, ->(category_id) { where("category_id = ? AND status = ?", category_id, "enable") }

  store :material, accessors: [ :material_1, :material_2]
  store :wash, accessors: [ :wash_1, :wash_2, :wash_3 ]
  store :model, accessors: [ :model_1, :model_2]

  #callback
  before_validation :check_attrs

  validates_presence_of :name, :price, :price_for_sale, :category_id
  validates_numericality_of :price , :only_integer => true , :greater_than_or_equal_to => :price_for_sale, :unless => "price_for_sale.nil?" 
  validates_numericality_of :price_for_sale , :only_integer => true , :greater_than => 0

  #before_destroy { |record| Banner.destroy_all "product_id = #{record.id}"  }
  after_create :create_default_measurements

  def check_attrs
    self.name = "未命名商品" if self.name.blank?
    self.en_name = "untitled product" if self.en_name.blank?
    self.price = 9999 if self.price.blank?
    self.price_for_sale = 9999 if self.price_for_sale.blank?
    self.status = "disable" if self.status.blank?
  end

  def get_status
    case self.status
    when "disable"
      "下架"
    when "enable"
      "上架"
    end   
  end

  def is_available?
    self.status == "enable" ? true : false
  end

  private

  def create_default_measurements
    #k-v pair: title:context
    @default_mesurements = [
      {title: '胸圍 Bust'},
      {title: '腰圍 Waist'},
      {title: '臂圍 Arm Circumference'},
      {title: '臀圍 Hip'},
      {title: '大腿圍 Thigh'},
      {title: '衣長 Clothes Length'},
      {title: '裙長 Skirt Length'},
      {title: '褲長 Pants Length'},
      {title: '袖長 Sleeve Length'   },
      {title: '肩帶長 Straps Length'},
      {title: '肩寬 Shoulder Length'},
      {title: '袖口 Sleeve Width'},
      {title: '領口 Collar Width'},
      {title: '後檔 Back Rise'},
      {title: '前檔 Front Rise'}
    ]

    @default_mesurements.each do | measurement |
      measurement.reverse_merge!(product_id: self.id , status: 'disable')
    end     
    
    Measurement.create(@default_mesurements)

  end

end
