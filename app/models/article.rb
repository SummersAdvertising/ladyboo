#encoding: utf-8
class Article < ActiveRecord::Base
  has_many :photos, :dependent => :destroy

  #delete the blank diretory built by carrierwave
  before_destroy :remember_id
  after_destroy :remove_id_directory

  def get_meta

  begin     
      parts = JSON.parse(self.content)
      
      meta = ''
      
      parts.each do | part |
        break if meta.length > 100
        next if part['type'] != 'p'
        
        meta += part['content']
        
      end
      
      return meta.gsub('&nbsp;', ' ')
    
  rescue
    return ''
  end
      
  end

  protected
  def remember_id
    @id = id
  end
  
  #need to check
  def remove_id_directory
    FileUtils.remove_dir("#{Rails.root}/public/uploads/peditor/article/#{@id}", :force => true)
  end
end
