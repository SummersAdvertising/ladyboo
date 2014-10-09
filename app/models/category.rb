#encoding: utf-8
class Category < ActiveRecord::Base

  has_many :products, dependent: :destroy

  belongs_to :daddy, :class_name => "Category", :foreign_key => 'parent_id' 
  has_many :children,  :class_name => "Category", :foreign_key => 'parent_id'
  has_many :galleries, -> { order('ranking, created_at') } , as: :attachable , dependent: :destroy
  
  scope :for_admin, -> { where( "parent_id != 0" ) }
  scope :without_root_node, -> { where( "parent_id != 0 AND depth = 2" ) }

  def self.return_root_node
    return Category.find_by('parent_id=0')
  end

  def self.get_level_hierarchy()
    
    if Rails.env.production?
      sql = "SELECT categories.id, categories.depth, categories.parent_id, categories.name FROM categories WHERE  categories.parent_id != 0 "
    else
      #local
      sql = "SELECT categories.id, categories.depth, categories.parent_id, categories.name FROM categories WHERE categories.parent_id != 0 "
    end

    return records_array = ActiveRecord::Base.connection.execute(sql)

  end

  #should be useful to create breadcrum
  def find_my_direct_parent
    
     self.findpapa
     directparents = @@directparent.dup
     @@directparent.clear
     
     return directparents
     
  end
  
  #find direct parent levle mainly for breadcrumb
  @@directparent = []
  def findpapa

    if self.parent_id == 0
        @@directparent << self
       return @@directparent
    end   
    
    if self.parent_id > 0  
        @@directparent << self
        daddy.findpapa
    end
    
  end

  def delete_children
    Category.destroy_all(id: self.descendents)
  end

  def descendents
    #children.preload(:parent).each do |child|  child.descendents end
   children.each do |child|
      [child] + child.descendents
    end
  end

end
